# ServiceHub – An AI-Powered Local Service Marketplace

ServiceHub is a comprehensive full-stack application designed to connect general users with nearby service providers such as electricians, drivers, plumbers, doctors, and more. Built using the MERN stack for the web (admin/service provider panel) and Flutter for the mobile app (general users), ServiceHub empowers local communities with smart, efficient, and reliable service access.

---

## 🔧 Technologies Used

### Web Panel (Service Provider/Admin)
- **MongoDB** – NoSQL database for storing user, service, and booking data
- **Express.js** – Server-side framework for API development
- **React.js** – Frontend UI for service provider and admin dashboard
- **Node.js** – Backend runtime environment
- **Cloudinary** – Image storage and management
- **JWT** – JSON Web Tokens for secure authentication

### Mobile App (General Users)
- **Flutter** – Cross-platform mobile app development
- **Dart** – Programming language for Flutter
- **Firebase** – Used for authentication, messaging, and notifications
- **Cloudinary** – Profile and service image handling
- **Google Maps API** – Location selection and display
- **GetX** – State management and routing

---

## 🧩 Key Features

### 👤 User Panel (Mobile App)
- User registration & login
- Profile update (with image)
- Browse services by category (e.g., electricians, doctors)
- Book appointments with service providers
- Chat with service providers
- Search and filter services (distance, rating)
- Rate and review services
- View provider location on map

### 🛠️ Service Provider/Admin Panel (Web)
- Service provider registration & login
- Profile and business info management
- View and manage bookings
- Chat with users
- View feedback and ratings
- Dashboard analytics and stats

---

## 🛠️ How to Run the Project

### Prerequisites
- [Node.js](https://nodejs.org/)
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [MongoDB](https://www.mongodb.com/)
- [Android Studio or VS Code](https://flutter.dev/docs/development/tools)

### Run Flutter App (User Panel)
```bash
cd servicehub_flutter
flutter pub get
flutter run
```

### Run Web App (Provider/Admin Panel)
```bash
cd servicehub_web
npm install
npm run dev
```

Ensure MongoDB is running locally or configure the connection string in the backend `.env` file.

---

## 📁 Project Structure

```
ServiceHub/
├── servicehub_flutter/     # Mobile app for general users (Flutter)
│   └── lib/
│       └── screens/
│       └── controllers/
│       └── models/
│       └── services/
├── servicehub_web/         # Web dashboard for service providers and admins (React)
│   └── src/
│       └── components/
│       └── pages/
│       └── api/
├── server/                 # Node.js + Express backend
│   └── routes/
│   └── models/
│   └── controllers/
│   └── middleware/
```

---

## 🌍 Deployment (Optional)
- Frontend can be deployed on **Vercel** or **Netlify**
- Backend on **Render** or **Heroku**
- MongoDB on **MongoDB Atlas**

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🤝 Acknowledgments

This project is a Final Year Project developed by:

- **Ihsan Ullah** – Flutter Developer & ML Engineer
- **Atta Ullah** – MERN Stack Developer

Supervised by **Engr. Shaukat Ali**  
Department of Software Engineering, University of Malakand

---

## 📫 Contact

If you have any questions, feel free to contact us:

- Ihsan Ullah: [GitHub Profile](https://github.com/ihsantech)
- Atta Ullah: [GitHub Profile](#)
