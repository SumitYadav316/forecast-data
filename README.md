<img width="1660" height="946" alt="first_page" src="https://github.com/user-attachments/assets/61199c1a-c630-4283-bcab-92d9f9406182" />
<img width="1667" height="994" alt="Screenshot from 2025-11-28 14-16-50" src="https://github.com/user-attachments/assets/e89fd3b6-e194-4d71-8488-a008a68b3a7a" />
# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# 🌦 Weather Forecast App (Ruby on Rails)

This is a simple weather lookup application built using **Ruby on Rails**.  
Users can enter an address or ZIP code, and the app fetches real-time weather data including **current weather** and a **7-day extended forecast**.

---

## 🚀 Features

- Search by **address** or **ZIP code**
- Current temperature, humidity, and conditions
- 7-day forecast table
- Caching to reduce repeated API calls
- Clean and modern UI

---

## 🛠 Requirements

- Ruby 3.4.7
- Rails 8.1.1
- Bundler
- PostgreSQL / SQLite (depending on your setup)
---
### 1️⃣ Clone the project

```bash
git clone https://github.com/yourname/weather-app.git
cd weather-app

bundle install
2️⃣ Setup the database
rails db:create
rails db:migrate
3️⃣ Add Your API Key (IMPORTANT)
  This project uses OpenWeatherMap API.
  This project uses dotenv for environment variables.
Step 1: Create a .env file in the project root
  touch .env
Step 2: Add your OpenWeather API key inside .env:
  OPENWEATHER_API_KEY=your_api_key_here

4️⃣ Start the browser
rails s
***********Open the app at browser **********:

http://localhost:3000
✅ Run all tests
bundle exec rspec
