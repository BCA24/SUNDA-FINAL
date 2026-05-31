const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const app = express();
const port = 3000;

// JWT Secret (in production, use environment variable)
const JWT_SECRET = 'caribbean_jwt_secret_2024!';

// Middleware
app.use(cors());
app.use(express.json());

// PostgreSQL connection
const pool = new Pool({
  user: 'caribbean_user',
  host: 'localhost',
  database: 'caribbean_real_estate',
  password: 'caribbean_secure_2024!',
  port: 5432,
});

// Test database connection
pool.connect((err, client, release) => {
  if (err) {
    console.error('❌ Error connecting to database:', err.stack);
  } else {
    console.log('✅ Connected to Caribbean Real Estate Database');
    release();
  }
});

// =====================================================
// WORDPRESS-COMPATIBLE ENDPOINTS (for Houzi compatibility)
// =====================================================

// WordPress-style registration endpoint
app.post('/wp-json/api/v1/register', async (req, res) => {
  console.log('📌 WordPress-style registration endpoint called');
  console.log('📋 Request body:', req.body);
  
  try {
    const { username, user_login, user_email, email, password, first_name, last_name, phone, phone_number } = req.body;
    
    const finalUsername = username || user_login || email || '';
    const finalEmail = user_email || email || '';
    const finalPhone = phone || phone_number || '';
    
    // Hash password
    const password_hash = await bcrypt.hash(password, 12);
    
    const query = `
      INSERT INTO users (
        username, email, password_hash, first_name, last_name, phone,
        role, status, email_verified, phone_verified
      ) VALUES (
        $1, $2, $3, $4, $5, $6,
        'user', 'active', true, false
      ) RETURNING id, username, email, first_name, last_name, role
    `;
    
    const params = [finalUsername, finalEmail, password_hash, first_name || finalUsername, last_name || '', finalPhone];
    const result = await pool.query(query, params);
    
    console.log('✅ User registered with ID:', result.rows[0].id);
    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      user: result.rows[0]
    });
  } catch (error) {
    console.error('❌ Error during registration:', error);
    res.status(500).json({ 
      success: false,
      error: 'Registration failed',
      message: error.message 
    });
  }
});

// =====================================================
// AUTHENTICATION ENDPOINTS
// =====================================================

// Agency Registration
app.post('/api/auth/agency-register', async (req, res) => {
  try {
    const { name, email, password, phone, address } = req.body;
    
    // Validate required fields
    if (!name || !email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Name, email, and password are required'
      });
    }
    
    // Check if email already exists
    const existingUser = await pool.query(
      'SELECT id FROM users WHERE email = $1',
      [email]
    );
    
    if (existingUser.rows.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'Email already registered'
      });
    }
    
    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Build username and name parts for required schema fields
    const nameParts = name.trim().split(/\s+/);
    const firstName = nameParts.shift() || name.trim();
    const lastName = nameParts.join(' ') || '';
    const usernameBase = name.trim().toLowerCase().replace(/\s+/g, '_').replace(/[^a-z0-9_]/g, '');
    const username = `${usernameBase}_${Date.now()}`;
    
    // Insert new agency user into users table
    const result = await pool.query(
      `INSERT INTO users (
         username, email, password_hash, first_name, last_name,
         phone, role, status, address, created_at
       ) VALUES (
         $1, $2, $3, $4, $5,
         $6, 'agent', 'active', $7, NOW()
       )
       RETURNING id, username, email, first_name as name, last_name, phone, role, address`,
      [username, email, hashedPassword, firstName, lastName, phone || null, address || null]
    );
    
    const user = result.rows[0];
    
    // Generate JWT token
    const token = jwt.sign(
      { 
        userId: user.id, 
        email: user.email, 
        role: user.role 
      },
      JWT_SECRET,
      { expiresIn: '30d' }
    );
    
    console.log(`✅ New agency registered: ${user.name} (${user.email})`);
    
    res.json({
      success: true,
      session_token: token,
      user: {
        id: user.id,
        username: user.username,
        name: `${user.name}`,
        email: user.email,
        phone: user.phone,
        role: user.role,
        address: user.address
      }
    });
    
  } catch (error) {
    console.error('❌ Agency registration error:', error);
    res.status(500).json({
      success: false,
      message: 'Registration failed'
    });
  }
});

// Agency Login
app.post('/api/auth/agency-login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email and password are required'
      });
    }
    
    // Find user by email in users table
    const result = await pool.query(
      'SELECT id, first_name || \' \' || last_name as name, email, password_hash, phone, role, status FROM users WHERE email = $1',
      [email]
    );
    
    if (result.rows.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password'
      });
    }
    
    const user = result.rows[0];
    
    // Check if user is active
    if (user.status !== 'active') {
      return res.status(401).json({
        success: false,
        message: 'Account is inactive'
      });
    }
    
    // Verify password
    const isValidPassword = await bcrypt.compare(password, user.password_hash);
    
    if (!isValidPassword) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password'
      });
    }
    
    // Generate JWT token
    const token = jwt.sign(
      { 
        userId: user.id, 
        email: user.email, 
        role: user.role 
      },
      JWT_SECRET,
      { expiresIn: '30d' }
    );
    
    console.log(`✅ User logged in: ${user.name} (${user.email}) - Role: ${user.role}`);
    
    res.json({
      success: true,
      session_token: token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role
      }
    });
    
  } catch (error) {
    console.error('❌ Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Login failed'
    });
  }
});

// Middleware to verify JWT token
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Access token required'
    });
  }
  
  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({
        success: false,
        message: 'Invalid or expired token'
      });
    }
    req.user = user;
    next();
  });
};

// Get current user info
app.get('/api/auth/me', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT id, name, email, phone, role, status FROM users WHERE id = $1',
      [req.user.userId]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }
    
    res.json({
      success: true,
      user: result.rows[0]
    });
    
  } catch (error) {
    console.error('❌ Get user error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get user info'
    });
  }
});

// =====================================================
// PROPERTY ENDPOINTS
// =====================================================

// Get properties with filtering
app.get('/api/properties', async (req, res) => {
  try {
    const {
      country,
      status = 'active',
      property_type,
      city,
      min_price,
      max_price,
      bedrooms,
      bathrooms,
      near_beach,
      has_pool,
      has_garden,
      has_parking,
      furnished,
      gated_community,
      ocean_view,
      new_construction
    } = req.query;

    let query = `
      SELECT 
        p.*,
        c.name as country_name,
        c.code as country_code,
        c.region,
        ct.name as city_name,
        COALESCE(NULLIF(u.first_name || ' ' || u.last_name, ' '), 'Unknown Owner') as owner_name,
        (SELECT image_url FROM property_images pi WHERE pi.property_id = p.id AND pi.is_primary = TRUE LIMIT 1) as primary_image
      FROM properties p
      JOIN countries c ON p.country_id = c.id
      LEFT JOIN cities ct ON p.city_id = ct.id
      LEFT JOIN users u ON p.user_id = u.id
      WHERE p.status = $1
    `;
    
    const params = [status];
    let paramIndex = 2;

    // Add country filter
    if (country) {
      if (country.length === 3) {
        // Country code (JAM, BHS, etc.)
        query += ` AND c.code = $${paramIndex}`;
      } else {
        // Country name
        query += ` AND c.name ILIKE $${paramIndex}`;
      }
      params.push(country);
      paramIndex++;
    }

    // Add other filters
    if (property_type) {
      query += ` AND p.property_type = $${paramIndex}`;
      params.push(property_type);
      paramIndex++;
    }

    if (city) {
      query += ` AND ct.name ILIKE $${paramIndex}`;
      params.push(`%${city}%`);
      paramIndex++;
    }

    if (min_price) {
      query += ` AND p.sale_price >= $${paramIndex}`;
      params.push(parseFloat(min_price));
      paramIndex++;
    }

    if (max_price) {
      query += ` AND p.sale_price <= $${paramIndex}`;
      params.push(parseFloat(max_price));
      paramIndex++;
    }

    if (bedrooms) {
      query += ` AND p.bedrooms = $${paramIndex}`;
      params.push(parseInt(bedrooms));
      paramIndex++;
    }

    if (bathrooms) {
      query += ` AND p.bathrooms = $${paramIndex}`;
      params.push(parseFloat(bathrooms));
      paramIndex++;
    }

    // Boolean filters
    if (near_beach === 'true') {
      query += ` AND p.near_beach = true`;
    }
    if (has_pool === 'true') {
      query += ` AND p.has_pool = true`;
    }
    if (has_garden === 'true') {
      query += ` AND p.has_garden = true`;
    }
    if (has_parking === 'true') {
      query += ` AND p.has_parking = true`;
    }
    if (furnished === 'true') {
      query += ` AND p.furnished = true`;
    }
    if (gated_community === 'true') {
      query += ` AND p.gated_community = true`;
    }
    if (ocean_view === 'true') {
      query += ` AND p.ocean_view = true`;
    }
    if (new_construction === 'true') {
      query += ` AND p.new_construction = true`;
    }

    query += ` ORDER BY p.published_at DESC`;

    console.log('🔍 Property query:', query);
    console.log('📊 Parameters:', params);

    const result = await pool.query(query, params);
    
    console.log(`✅ Found ${result.rows.length} properties`);
    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error fetching properties:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get properties by country name
app.get('/api/properties/country/:countryName', async (req, res) => {
  try {
    const { countryName } = req.params;
    
    console.log(`🔍 Fetching properties for country: ${countryName}`);
    
    const query = `
      SELECT 
        p.*,
        c.name as country_name,
        c.code as country_code,
        c.region,
        ct.name as city_name,
        COALESCE(NULLIF(u.first_name || ' ' || u.last_name, ' '), 'Unknown Owner') as owner_name,
        (SELECT image_url FROM property_images pi WHERE pi.property_id = p.id AND pi.is_primary = TRUE LIMIT 1) as primary_image
      FROM properties p
      JOIN countries c ON p.country_id = c.id
      LEFT JOIN cities ct ON p.city_id = ct.id
      LEFT JOIN users u ON p.user_id = u.id
      WHERE p.status = 'active' AND c.name ILIKE $1
      ORDER BY p.published_at DESC
    `;
    
    const result = await pool.query(query, [countryName]);
    
    console.log(`✅ Found ${result.rows.length} properties in ${countryName}`);
    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error fetching properties by country:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get property by ID
app.get('/api/properties/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const query = `
      SELECT 
        p.*,
        c.name as country_name,
        c.code as country_code,
        c.region,
        ct.name as city_name,
        COALESCE(NULLIF(u.first_name || ' ' || u.last_name, ' '), 'Unknown Owner') as owner_name,
        u.email as owner_email,
        u.phone as owner_phone
      FROM properties p
      JOIN countries c ON p.country_id = c.id
      LEFT JOIN cities ct ON p.city_id = ct.id
      LEFT JOIN users u ON p.user_id = u.id
      WHERE p.id = $1
    `;
    
    const result = await pool.query(query, [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Property not found' });
    }
    
    // Get property images
    const imagesQuery = `
      SELECT image_url, thumbnail_url, alt_text, display_order, is_primary
      FROM property_images
      WHERE property_id = $1
      ORDER BY display_order
    `;
    const imagesResult = await pool.query(imagesQuery, [id]);
    
    const property = result.rows[0];
    property.images = imagesResult.rows;
    
    res.json(property);
  } catch (error) {
    console.error('❌ Error fetching property:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Create new property
app.post('/api/properties', async (req, res) => {
  try {
    console.log('🏠 Creating new property...');
    console.log('📋 Request body:', req.body);
    console.log('🟠 sale_price received:', req.body.sale_price);
    
    const {
      user_id,
      title,
      description,
      property_type,
      listing_type = 'sale',
      country_id,
      city_name, // Accept city name instead of city_id
      address,
      latitude,
      longitude,
      bedrooms,
      bathrooms,
      area_sqm,
      construction_year,
      sale_price,
      rent_price_monthly,
      currency_code = 'USD',
      near_beach = false,
      ocean_view = false,
      furnished = false,
      has_pool = false,
      has_garden = false,
      has_parking = false,
      gated_community = false,
      new_construction = false,
      contact_phone,
      contact_email
    } = req.body;

    // Validate and fix area_sqm to meet database constraint (must be > 0)
    const validatedAreaSqm = area_sqm && area_sqm > 0 ? area_sqm : 50.0; // Default to 50 sqm if not provided or invalid
    console.log(`📏 Area validation: original=${area_sqm}, validated=${validatedAreaSqm}`);
    
    // Validate country_id
    if (!country_id) {
      return res.status(400).json({ 
        error: 'Missing country_id', 
        details: 'Property must be associated with a valid country' 
      });
    }
    console.log(`🌍 Country ID provided: ${country_id}`);

    // Check if user exists, if not use a valid existing sample user
    let finalUserId = user_id;
    if (!finalUserId || finalUserId === 'cd29948f-a00f-44ff-beab-101f8664a46f') {
      finalUserId = '550e8400-e29b-41d4-a716-446655440000';
      console.log('🔍 Using fallback existing sample user ID:', finalUserId);
    }

    // Validate that the resolved user actually exists
    try {
      const userCheck = await pool.query('SELECT id FROM users WHERE id = $1', [finalUserId]);
      if (userCheck.rows.length === 0) {
        finalUserId = '550e8400-e29b-41d4-a716-446655440000';
        console.log('⚠️ Provided user_id not found, falling back to sample user ID:', finalUserId);
      }
    } catch (userCheckError) {
      console.log('⚠️ User validation error:', userCheckError.message);
    }

    // Handle city name to city_id conversion
    let finalCityId = null;
    if (city_name && city_name.trim() !== '' && city_name.toLowerCase() !== 'default city') {
      try {
        // First check if city already exists
        const existingCity = await pool.query(
          'SELECT id FROM cities WHERE LOWER(name) = LOWER($1) AND country_id = $2',
          [city_name.trim(), country_id]
        );
        
        if (existingCity.rows.length > 0) {
          finalCityId = existingCity.rows[0].id;
          console.log(`🏙️ Found existing city "${city_name}" with ID: ${finalCityId}`);
        } else {
          // Create new city
          const newCity = await pool.query(`
            INSERT INTO cities (name, country_id, created_at) 
            VALUES ($1, $2, CURRENT_TIMESTAMP) 
            RETURNING id
          `, [city_name.trim(), country_id]);
          finalCityId = newCity.rows[0].id;
          console.log(`✅ Created new city "${city_name}" with ID: ${finalCityId}`);
        }
      } catch (cityError) {
        console.log('⚠️ Error handling city:', cityError.message);
        finalCityId = null; // Will be handled below
      }
    }
    
    // If no city_id was found/created, create a default "General" city
    if (!finalCityId) {
      try {
        console.log('🔄 No city provided, creating default "General" city...');
        const defaultCity = await pool.query(`
          INSERT INTO cities (name, country_id, created_at) 
          VALUES ('General', $1, CURRENT_TIMESTAMP) 
          ON CONFLICT (name, country_id) DO UPDATE SET name = EXCLUDED.name
          RETURNING id
        `, [country_id]);
        finalCityId = defaultCity.rows[0].id;
        console.log('✅ Created/found default city "General" with ID:', finalCityId);
      } catch (fallbackError) {
        console.log('❌ Failed to create default city:', fallbackError.message);
        // Last resort - use city_id 1 if it exists
        try {
          const fallbackCity = await pool.query('SELECT id FROM cities WHERE id = 1');
          if (fallbackCity.rows.length > 0) {
            finalCityId = 1;
            console.log('🆘 Using fallback city_id: 1');
          } else {
            throw new Error('No fallback city available');
          }
        } catch (lastError) {
          console.log('💥 Complete city failure:', lastError.message);
          return res.status(500).json({ 
            error: 'City creation failed', 
            details: 'Unable to create or find any city for this property' 
          });
        }
      }
    }

    console.log('📊 Final parameters:');
    console.log('- User ID:', finalUserId);
    console.log('- Title:', title);
    console.log('- Country ID:', country_id);
    console.log('- City ID:', finalCityId);
    console.log('- Area (sqm):', validatedAreaSqm);
    console.log('- Country ID:', country_id);
    console.log('- City Name:', city_name);
    console.log('- Final City ID:', finalCityId);
    console.log('- Address:', address);

    const query = `
      INSERT INTO properties (
        user_id, title, description, property_type, listing_type, status,
        country_id, city_id, address, latitude, longitude,
        bedrooms, bathrooms, area_sqm, construction_year,
        sale_price, rent_price_monthly, currency_code,
        near_beach, ocean_view, furnished, has_pool, has_garden, has_parking,
        gated_community, new_construction,
        contact_phone, contact_email, published_at, created_at
      ) VALUES (
        $1, $2, $3, $4, $5, 'active',
        $6, $7, $8, $9, $10,
        $11, $12, $13, $14,
        $15, $16, $17,
        $18, $19, $20, $21, $22, $23,
        $24, $25,
        $26, $27, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      ) RETURNING id
    `;

    const params = [
      finalUserId, title, description, property_type, listing_type,
      country_id, finalCityId, address, latitude, longitude,
      bedrooms, bathrooms, validatedAreaSqm, construction_year,
      sale_price, rent_price_monthly, currency_code,
      near_beach, ocean_view, furnished, has_pool, has_garden, has_parking,
      gated_community, new_construction,
      contact_phone, contact_email
    ];
    console.log('🟢 sale_price param for DB:', sale_price);

    console.log('📝 Executing query with parameters:', params.slice(0, 5)); // Log first 5 params for debugging
    
    const result = await pool.query(query, params);
    
    console.log('✅ Property created with ID:', result.rows[0].id);
    
    // Verify the property was created with correct country association
    const verifyQuery = `
      SELECT p.id, p.title, p.country_id, c.name as country_name, p.status
      FROM properties p 
      LEFT JOIN countries c ON p.country_id = c.id 
      WHERE p.id = $1
    `;
    const verifyResult = await pool.query(verifyQuery, [result.rows[0].id]);
    console.log('🔍 Created property details:', verifyResult.rows[0]);
    
    res.status(201).json({ 
      id: result.rows[0].id, 
      message: 'Property created successfully',
      property_details: verifyResult.rows[0]
    });
  } catch (error) {
    console.error('❌ Error creating property:', error);
    console.error('❌ Error details:', error.message);
    console.error('❌ Error code:', error.code);
    res.status(500).json({ 
      error: 'Internal server error',
      details: error.message,
      code: error.code
    });
  }
});

// =====================================================
// COUNTRY ENDPOINTS
// =====================================================

// Get countries with property counts
app.get('/api/countries', async (req, res) => {
  try {
    const query = `
      SELECT 
        c.id,
        c.code,
        c.name,
        c.region,
        c.currency_code,
        COUNT(p.id) as property_count
      FROM countries c
      LEFT JOIN properties p ON c.id = p.country_id AND p.status = 'active'
      GROUP BY c.id, c.code, c.name, c.region, c.currency_code
      ORDER BY c.id
    `;
    
    const result = await pool.query(query);
    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error fetching countries:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// =====================================================
// USER AUTHENTICATION ENDPOINTS
// =====================================================

// User login (supports both username and email)
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    // Try to find user by email OR username
    const query = `
      SELECT id, username, email, password_hash, first_name, last_name, role, status
      FROM users
      WHERE (email = $1 OR username = $1) AND status = 'active'
    `;
    
    const result = await pool.query(query, [email]); // 'email' param name is kept for backwards compatibility, but accepts username too
    
    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    
    const user = result.rows[0];
    const isValidPassword = await bcrypt.compare(password, user.password_hash);
    
    if (!isValidPassword) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    
    // Remove password hash from response
    delete user.password_hash;
    
    // In a real app, you'd generate a JWT token here
    const token = 'mock_jwt_token_' + user.id;
    
    console.log(`✅ User logged in: ${user.username} (${user.email})`);
    
    res.json({
      user,
      token,
      message: 'Login successful'
    });
  } catch (error) {
    console.error('❌ Error during login:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// User registration
app.post('/api/auth/register', async (req, res) => {
  try {
    const {
      username,
      email,
      password,
      first_name,
      last_name,
      phone,
      country_id,
      city_id
    } = req.body;
    
    // Check if user already exists (by email or username)
    const existingUser = await pool.query('SELECT id FROM users WHERE email = $1 OR username = $2', [email, username]);
    if (existingUser.rows.length > 0) {
      return res.status(400).json({ error: 'User already exists' });
    }
    
    // Hash password
    const password_hash = await bcrypt.hash(password, 12);
    
    const query = `
      INSERT INTO users (
        username, email, password_hash, first_name, last_name, phone,
        role, status, country_id, city_id, email_verified, phone_verified
      ) VALUES (
        $1, $2, $3, $4, $5, $6,
        'user', 'active', $7, $8, true, false
      ) RETURNING id, username, email, first_name, last_name, role
    `;
    
    const params = [username, email, password_hash, first_name, last_name, phone, country_id, city_id];
    const result = await pool.query(query, params);
    
    console.log('✅ User registered with ID:', result.rows[0].id);
    res.status(201).json({
      user: result.rows[0],
      message: 'User registered successfully'
    });
  } catch (error) {
    console.error('❌ Error during registration:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// =====================================================
// USER INTERACTION ENDPOINTS
// =====================================================

// Add to favorites
app.post('/api/users/:userId/favorites', async (req, res) => {
  try {
    const { userId } = req.params;
    const { property_id } = req.body;
    
    const query = `
      INSERT INTO user_favorites (user_id, property_id)
      VALUES ($1, $2)
      ON CONFLICT (user_id, property_id) DO NOTHING
    `;
    
    await pool.query(query, [userId, property_id]);
    res.status(201).json({ message: 'Added to favorites' });
  } catch (error) {
    console.error('❌ Error adding to favorites:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Submit inquiry
app.post('/api/inquiries', async (req, res) => {
  try {
    const {
      property_id,
      user_id,
      name,
      email,
      phone,
      message,
      inquiry_type = 'general'
    } = req.body;
    
    const query = `
      INSERT INTO property_inquiries (
        property_id, user_id, name, email, phone, message, inquiry_type
      ) VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING id
    `;
    
    const params = [property_id, user_id, name, email, phone, message, inquiry_type];
    const result = await pool.query(query, params);
    
    console.log('✅ Inquiry submitted with ID:', result.rows[0].id);
    res.status(201).json({ message: 'Inquiry submitted successfully' });
  } catch (error) {
    console.error('❌ Error submitting inquiry:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// =====================================================
// TEST ENDPOINTS
// =====================================================

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'Caribbean Real Estate API is running',
    timestamp: new Date().toISOString()
  });
});

// Database test
app.get('/api/test/db', async (req, res) => {
  try {
    const result = await pool.query('SELECT COUNT(*) as total_properties FROM properties WHERE status = $1', ['active']);
    const countryResult = await pool.query('SELECT COUNT(*) as total_countries FROM countries');
    
    res.json({
      status: 'Database connected',
      active_properties: parseInt(result.rows[0].total_properties),
      total_countries: parseInt(countryResult.rows[0].total_countries),
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('❌ Database test failed:', error);
    res.status(500).json({ error: 'Database connection failed' });
  }
});

// Start server
app.listen(port, '0.0.0.0', () => {
  console.log('🚀 Caribbean Real Estate API Server started');
  console.log(`📡 Server running at http://localhost:${port}`);
  console.log(`📱 Also accessible from network at http://172.16.100.201:${port}`);
  console.log('🔗 API endpoints:');
  console.log('   GET  /api/health - Health check');
  console.log('   GET  /api/test/db - Database test');
  console.log('   GET  /api/properties - Get properties with filters');
  console.log('   POST /api/properties - Create new property');
  console.log('   GET  /api/countries - Get countries with property counts');
  console.log('   POST /api/auth/login - User login');
  console.log('   POST /api/auth/register - User registration');
  console.log('');
  console.log('🧪 Test the API:');
  console.log(`   curl http://localhost:${port}/api/health`);
  console.log(`   curl http://localhost:${port}/api/test/db`);
  console.log(`   curl "http://localhost:${port}/api/properties?country=JAM"`);
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n🛑 Shutting down server...');
  pool.end(() => {
    console.log('✅ Database connections closed');
    process.exit(0);
  });
});
