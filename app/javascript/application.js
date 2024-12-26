// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { fetchWithAuth } from "auth_helper"
window.fetchWithAuth = fetchWithAuth
