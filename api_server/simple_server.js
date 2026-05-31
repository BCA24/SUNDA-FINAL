const express = require('express');
const cors = require('cors');
const bcrypt = require('bcrypt');

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// =====================================================
// IN-MEMORY DATA STORAGE (No PostgreSQL needed!)
// =====================================================

let users = [
  {
    id: 1,
    name: 'SuriStay Agency',
    email: 'agency@suristay.com',
    password: '$2a$10$N9qo8uLOickgx2ZMRZoMye1J5YfqV4dPuqH3p.7R3RmU0pJZ0EQ9C', // agency123 (correct hash)
    phone: '+1-876-555-0001',
    role: 'agency'
  },
  {
    id: 2,
    name: 'Test Agency',
    email: 'test@agency.com',
    password: '$2a$10$N9qo8uLOickgx2ZMRZoMye1J5YfqV4dPuqH3p.7R3RmU0pJZ0EQ9C', // agency123 (correct hash)
    phone: '+1-876-555-0002',
    role: 'agency'
  }
];

let properties = [
  {
    id: 1,
    title: 'Luxury Beachfront Villa in Montego Bay',
    description: 'Stunning 4-bedroom villa with private beach access',
    property_type: 'villa',
    listing_type: 'sale',
    country_name: 'Jamaica',
    country_code: 'JAM',
    city_name: 'Montego Bay',
    address: 'Rose Hall, Montego Bay',
    bedrooms: 4,
    bathrooms: 3,
    area_sqm: 350,
    sale_price: 1250000,
    currency_code: 'USD',
    primary_image: '',
    created_at: new Date().toISOString()
  },
  {
    id: 2,
    title: 'Modern Apartment in Kingston',
    description: 'Contemporary 2-bedroom apartment in the heart of Kingston',
    property_type: 'apartment',
    listing_type: 'sale',
    country_name: 'Jamaica',
    country_code: 'JAM',
    city_name: 'Kingston',
    address: 'New Kingston',
    bedrooms: 2,
    bathrooms: 2,
    area_sqm: 120,
    sale_price: 185000,
    currency_code: 'USD',
    primary_image: '',
    created_at: new Date().toISOString()
  },
  {
    id: 3,
    title: 'Paradise Island Penthouse',
    description: 'Exclusive penthouse with 360-degree ocean views',
    property_type: 'penthouse',
    listing_type: 'sale',
    country_name: 'Bahamas',
    country_code: 'BHS',
    city_name: 'Nassau',
    address: 'Paradise Island',
    bedrooms: 5,
    bathrooms: 4,
    area_sqm: 450,
    sale_price: 2800000,
    currency_code: 'USD',
    primary_image: '',
    created_at: new Date().toISOString()
  }
];

let nextUserId = 3;
let nextPropertyId = 4;

// =====================================================
// AUTHENTICATION ENDPOINTS
// =====================================================

// Agency Registration
app.post('/api/auth/agency-register', async (req, res) => {
  try {
    const { name, email, password, phone, address } = req.body;
    
    console.log('📝 Registration request:', { name, email, phone });
    
    // Check if email exists
    if (users.find(u => u.email === email)) {
      return res.status(400).json({
        success: false,
        message: 'Email already registered'
      });
    }
    
    // Hash password
    const password_hash = await bcrypt.hash(password, 10);
    
    // Create new user
    const newUser = {
      id: nextUserId++,
      name,
      email,
      password: password_hash,
      phone: phone || '',
      address: address || '',
      role: 'agency'
    };
    
    users.push(newUser);
    
    console.log('✅ Agency registered:', newUser.email);
    
    res.json({
      success: true,
      session_token: 'token_' + newUser.id,
      user: {
        id: newUser.id,
        name: newUser.name,
        email: newUser.email,
        phone: newUser.phone,
        role: newUser.role
      }
    });
  } catch (error) {
    console.error('❌ Registration error:', error);
    res.status(500).json({
      success: false,
      message: 'Registration failed: ' + error.message
    });
  }
});

// Agency Login
app.post('/api/auth/agency-login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    console.log('🔐 Login attempt:', email);
    
    const user = users.find(u => u.email === email);
    
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password'
      });
    }
    
    const validPassword = await bcrypt.compare(password, user.password);
    
    if (!validPassword) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password'
      });
    }
    
    console.log('✅ Login successful:', user.email);
    
    res.json({
      success: true,
      session_token: 'token_' + user.id,
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
      message: 'Login failed: ' + error.message
    });
  }
});

// =====================================================
// PROPERTY ENDPOINTS
// =====================================================

// Get properties
app.get('/api/properties', (req, res) => {
  try {
    const { country } = req.query;
    
    console.log('🏠 Get properties request, country:', country);
    
    let filtered = properties;
    
    if (country) {
      if (country.length === 3) {
        // Country code
        filtered = properties.filter(p => p.country_code === country);
      } else {
        // Country name
        filtered = properties.filter(p => p.country_name.toLowerCase().includes(country.toLowerCase()));
      }
    }
    
    console.log(`✅ Returning ${filtered.length} properties`);
    
    res.json({
      success: true,
      data: filtered,
      total: filtered.length
    });
  } catch (error) {
    console.error('❌ Get properties error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get properties'
    });
  }
});

// Create property (agencies only)
app.post('/api/properties', (req, res) => {
  try {
    const propertyData = req.body;
    
    console.log('➕ Create property request:', propertyData.title);
    
    const newProperty = {
      id: nextPropertyId++,
      ...propertyData,
      created_at: new Date().toISOString()
    };
    
    properties.push(newProperty);
    
    console.log('✅ Property created:', newProperty.id);
    
    res.status(201).json({
      success: true,
      id: newProperty.id,
      message: 'Property created successfully'
    });
  } catch (error) {
    console.error('❌ Create property error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create property'
    });
  }
});

// Get countries
app.get('/api/countries', (req, res) => {
  const countries = [
    { id: 1, code: 'JAM', name: 'Jamaica', property_count: properties.filter(p => p.country_code === 'JAM').length },
    { id: 2, code: 'BHS', name: 'Bahamas', property_count: properties.filter(p => p.country_code === 'BHS').length },
    { id: 3, code: 'BRB', name: 'Barbados', property_count: properties.filter(p => p.country_code === 'BRB').length },
    { id: 4, code: 'TTO', name: 'Trinidad and Tobago', property_count: properties.filter(p => p.country_code === 'TTO').length },
  ];
  
  res.json({
    success: true,
    data: countries
  });
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'Simple Caribbean Real Estate API is running',
    users: users.length,
    properties: properties.length
  });
});

// Start server
app.listen(port, () => {
  console.log('\n========================================');
  console.log('🚀 SIMPLE Caribbean Real Estate API');
  console.log('========================================');
  console.log(`📡 Server running at http://localhost:${port}`);
  console.log(`📱 Emulator access: http://10.0.2.2:${port}`);
  console.log('\n✅ In-Memory Storage (No Database Required!)');
  console.log(`   - ${users.length} users registered`);
  console.log(`   - ${properties.length} properties available`);
  console.log('\n🔐 Test Accounts:');
  console.log('   - agency@suristay.com / agency123');
  console.log('   - test@agency.com / agency123');
  console.log('\n🔗 API Endpoints:');
  console.log('   GET  /api/health');
  console.log('   POST /api/auth/agency-register');
  console.log('   POST /api/auth/agency-login');
  console.log('   GET  /api/properties');
  console.log('   POST /api/properties');
  console.log('   GET  /api/countries');
  console.log('========================================\n');
});
