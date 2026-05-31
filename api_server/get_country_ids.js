const { Pool } = require('pg');

const pool = new Pool({
  user: 'caribbean_user',
  host: 'localhost',
  database: 'caribbean_real_estate',
  password: 'caribbean_secure_2024!',
  port: 5432,
});

async function getCountryIds() {
  try {
    console.log('🔍 Fetching country IDs from database...\n');
    
    const result = await pool.query(`
      SELECT id, code, name, region 
      FROM countries 
      ORDER BY id
    `);
    
    console.log('📊 Country IDs in database:\n');
    result.rows.forEach(country => {
      console.log(`ID: ${country.id} | ${country.code} | ${country.name} (${country.region})`);
    });
    
    console.log('\n✅ Total countries:', result.rows.length);
    
    // Find Bahamas specifically
    const bahamas = result.rows.find(c => c.code === 'BHS');
    if (bahamas) {
      console.log(`\n🏝️ BAHAMAS ID: ${bahamas.id}`);
    }
    
    await pool.end();
  } catch (error) {
    console.error('❌ Error:', error);
    await pool.end();
  }
}

getCountryIds();
