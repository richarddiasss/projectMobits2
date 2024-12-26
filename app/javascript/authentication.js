// app/javascript/authentication.js
class AuthService {
    static getToken() {
      return localStorage.getItem('token');
    }
  
    static setToken(token) {
      localStorage.setItem('token', token);
    }
  
    static removeToken() {
      localStorage.removeItem('token');
    }
  
    static isAuthenticated() {
      return !!this.getToken();
    }
  
    static async checkAuthStatus() {
      const token = this.getToken();
      if (!token) {
        window.location.href = '/login';
        return false;
      }
  
      try {
        const response = await fetch('/api/verify_token', {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        });
  
        if (!response.ok) {
          this.removeToken();
          window.location.href = '/login';
          return false;
        }
  
        return true;
      } catch (error) {
        this.removeToken();
        window.location.href = '/login';
        return false;
      }
    }
  }