## **README.md**

<div align="center">

# 🏢 HRIS Admin Dashboard - React 19

**Human Resource Information System - Admin Dashboard dengan React 19 + Vite**

[![React](https://img.shields.io/badge/React-19-61DAFB?style=for-the-badge&logo=react&logoColor=white)](https://reactjs.org/)
[![Vite](https://img.shields.io/badge/Vite-7-646CFF?style=for-the-badge&logo=vite&logoColor=white)](https://vitejs.dev/)
[![Tailwind](https://img.shields.io/badge/Tailwind-4-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)](https://tailwindcss.com/)
[![Axios](https://img.shields.io/badge/Axios-1.8-5A29E4?style=for-the-badge&logo=axios&logoColor=white)](https://axios-http.com/)
[![React Router](https://img.shields.io/badge/React_Router-7-CA4245?style=for-the-badge&logo=react-router&logoColor=white)](https://reactrouter.com/)

**Admin Dashboard untuk HRIS System - Terintegrasi dengan Backend Laravel 12 API**

</div>

---

## ✨ Features

- 🔐 **Authentication** - Login/Logout dengan JWT token dari Laravel Sanctum
- 👥 **Employee Management** - CRUD karyawan dengan validasi
- 🏢 **Department Management** - Manajemen divisi perusahaan
- ⏱️ **Attendance Tracking** - Lihat rekap absensi
- 📝 **Leave Management** - Approval cuti & lihat sisa cuti
- 📊 **Dashboard Analytics** - Grafik dan statistik real-time
- 🌓 **Dark/Light Mode** - Toggle tema
- 📱 **Responsive Design** - Mobile friendly dengan Tailwind
- 🔔 **Real-time Notifications** - Toast notifications

---

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- npm / yarn / pnpm
- Backend Laravel 12 running (http://127.0.0.1:8000)

### Installation

```bash
# 1. Clone repository
git clone https://github.com/yourusername/hris-system.git
cd hris-system/admin-react

# 2. Install dependencies
npm install

# 3. Copy environment file
cp .env.example .env

# 4. Start development server
npm run dev
```

### Login Demo
- **Email**: admin@example.com
- **Password**: password

---

## 🏗️ Project Structure

```
admin-react/
├── public/                    # Static files
├── src/
│   ├── components/            # Reusable components
│   │   ├── common/            # Button, Modal, Table, etc.
│   │   ├── charts/            # Chart components
│   │   └── forms/              # Form components
│   ├── context/                # React Context (Auth, Theme, Notification)
│   ├── hooks/                  # Custom hooks
│   ├── layouts/                 # Layout components
│   ├── pages/                   # Page components
│   │   ├── auth/                # Login, Logout
│   │   ├── dashboard/           # Dashboard
│   │   ├── employees/           # Employee CRUD
│   │   ├── departments/         # Department CRUD
│   │   ├── attendance/          # Attendance
│   │   ├── leaves/              # Leave management
│   │   ├── reports/             # Reports
│   │   └── settings/            # Settings
│   ├── services/                # API services
│   └── utils/                    # Utility functions
├── .env.example                  # Environment variables
├── index.html                    # HTML entry
├── package.json                  # Dependencies
├── tailwind.config.js            # Tailwind config
└── vite.config.js                # Vite config
```

---

## 📦 Dependencies

```json
{
  "react": "^19.0.0",
  "react-router-dom": "^7.5.1",
  "axios": "^1.8.4",
  "recharts": "^2.15.2",
  "date-fns": "^4.1.0",
  "react-hot-toast": "^2.5.2",
  "lucide-react": "^0.477.0",
  "react-hook-form": "^7.55.0",
  "react-table": "^7.8.0"
}
```

---

## 🔌 API Integration

Base URL: `http://127.0.0.1:8000/api`

### Authentication
- `POST /login` - Login
- `POST /logout` - Logout
- `GET /me` - Get current user

### Employees
- `GET /employees` - List all employees
- `GET /employees/{id}` - Get employee by ID
- `POST /employees` - Create employee
- `PUT /employees/{id}` - Update employee
- `DELETE /employees/{id}` - Delete employee

### Departments
- `GET /departments` - List departments
- `POST /departments` - Create department
- `GET /departments/{id}` - Get department
- `PUT /departments/{id}` - Update department
- `DELETE /departments/{id}` - Delete department

### Attendance
- `POST /attendance/check-in` - Check in
- `POST /attendance/check-out` - Check out
- `GET /attendance` - List attendance
- `GET /attendance/summary/{user}` - Monthly summary

### Leaves
- `GET /leaves` - List leaves
- `POST /leaves` - Create leave request
- `POST /leaves/{id}/approve` - Approve leave
- `POST /leaves/{id}/reject` - Reject leave
- `GET /leaves/balance/{user}` - Leave balance

---

## 🎨 Theme Configuration

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: '#3B82F6',
        secondary: '#6B7280',
        success: '#22C55E',
        danger: '#EF4444',
        warning: '#F59E0B'
      }
    }
  }
}
```

---

## 🤝 Integrasi dengan Backend

### 1. Pastikan Backend Running
```bash
cd ../backend-laravel
php artisan serve
# Server running on http://127.0.0.1:8000
```

### 2. Set Environment
```env
VITE_API_URL=http://127.0.0.1:8000/api
```

### 3. CORS Configuration (Backend)
Di `.env` backend tambahkan:
```env
SANCTUM_STATEFUL_DOMAINS=localhost:5173,localhost:3000
SESSION_DOMAIN=localhost
```

---

## 🧪 Testing

```bash
# Run development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

---

## 📱 Screenshots

*(Tambahkan screenshot di sini)*

---

## 🤝 Kontribusi

1. Fork repository
2. Buat branch fitur (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

---

## 📝 Lisensi

MIT License

---

## 📬 Kontak

- **Developer**: [Nama Anda]
- **Email**: [email@example.com]
- **Project Link**: [https://github.com/yourusername/hris-system](https://github.com/yourusername/hris-system)

---

<div align="center">

**Dibuat dengan ❤️ menggunakan React 19 + Vite + TailwindCSS**

⭐ **Jangan lupa beri star jika project ini bermanfaat!** ⭐

</div>
```

## **Cara Menjalankan**

```bash
# 1. Install dependencies
cd admin-react
npm install

# 2. Copy .env
cp .env.example .env

# 3. Jalankan development server
npm run dev
```

Akses di `http://localhost:5173`

Login dengan:
- **Email**: admin@example.com
- **Password**: password

**Selesai! 🎉 React Admin Dashboard siap digunakan!**