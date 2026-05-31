const http = require('http');

// Register user berk
const registerData = JSON.stringify({
  username: 'berk',
  email: 'berk@example.com',
  password: 'Password123.',
  first_name: 'Berk',
  last_name: 'User',
  phone: '+1234567890'
});

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/api/auth/register',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': registerData.length
  }
};

console.log('🔐 Registering user: berk');
console.log('📧 Email: berk@example.com');
console.log('🔑 Password: Password123.');

const req = http.request(options, (res) => {
  let data = '';

  res.on('data', (chunk) => {
    data += chunk;
  });

  res.on('end', () => {
    console.log('\n📊 Response Status:', res.statusCode);
    console.log('📄 Response:', data);
    
    if (res.statusCode === 201 || res.statusCode === 200) {
      console.log('\n✅ User registered successfully!');
      console.log('👤 You can now login with:');
      console.log('   Username: berk');
      console.log('   Password: Password123.');
    } else if (res.statusCode === 400) {
      console.log('\n⚠️ User may already exist. Attempting login test...');
      testLogin();
    } else {
      console.log('\n❌ Registration failed!');
    }
  });
});

req.on('error', (error) => {
  console.error('❌ Error:', error);
});

req.write(registerData);
req.end();

// Test login function
function testLogin() {
  const loginData = JSON.stringify({
    email: 'berk',
    password: 'Password123.'
  });

  const loginOptions = {
    hostname: 'localhost',
    port: 3000,
    path: '/api/auth/login',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': loginData.length
    }
  };

  console.log('\n🔐 Testing login for user: berk');

  const loginReq = http.request(loginOptions, (res) => {
    let data = '';

    res.on('data', (chunk) => {
      data += chunk;
    });

    res.on('end', () => {
      console.log('📊 Login Response Status:', res.statusCode);
      console.log('📄 Login Response:', data);
      
      if (res.statusCode === 200) {
        console.log('\n✅ Login successful! User exists and password is correct.');
      } else {
        console.log('\n❌ Login failed!');
      }
    });
  });

  loginReq.on('error', (error) => {
    console.error('❌ Login Error:', error);
  });

  loginReq.write(loginData);
  loginReq.end();
}
