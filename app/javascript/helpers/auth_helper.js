// app/javascript/helpers/auth_helper.js
async function fetchWithAuth(url, options = {}) {
    const token = localStorage.getItem('token');
    const headers = {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json',
      ...options.headers
    };
  
    const response = await fetch(url, {
      ...options,
      headers
    });
  
    if (response.status === 401) {
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
  
    return response;
  }