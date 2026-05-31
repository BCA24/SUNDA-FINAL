const { Pool } = require('pg');

const pool = new Pool({
  user: 'caribbean_user',
  host: 'localhost',
  database: 'caribbean_real_estate',
  password: 'caribbean_secure_2024!',
  port: 5432
});

async function checkDatabase() {
  try {
    console.log('🔍 Checking database for properties...\n');
    
    // Check properties
    const propResult = await pool.query(`
      SELECT 
        p.id, 
        p.title, 
        p.status, 
        p.property_type, 
        p.country_id,
        c.name as country_name,
        c.code as country_code
      FROM properties p
      LEFT JOIN countries c ON p.country_id = c.id
      ORDER BY p.created_at DESC
    `);
    
    console.log(`📊 Found ${propResult.rows.length} properties in database:\n`);
    propResult.rows.forEach((prop, idx) => {
      console.log(`${idx + 1}. ${prop.title}`);
      console.log(`   ID: ${prop.id}`);
      console.log(`   Status: ${prop.status}`);
      console.log(`   Type: ${prop.property_type}`);
      console.log(`   Country: ${prop.country_name} (${prop.country_code})`);
      console.log('');
    });
    
    // Check countries
    const countryResult = await pool.query(`
      SELECT id, code, name, region 
      FROM countries 
      ORDER BY name
    `);
    
    console.log(`\n🌎 Available countries (${countryResult.rows.length}):`);
    countryResult.rows.forEach(country => {
      console.log(`   ${country.code} - ${country.name} (${country.region})`);
    });
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await pool.end();
  }
}

checkDatabase();
