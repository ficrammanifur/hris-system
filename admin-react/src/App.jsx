import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider } from './context/AuthContext.jsx'
import { ThemeProvider } from './context/ThemeContext.jsx'
import { NotificationProvider } from './context/NotificationContext.jsx'
import { Toaster } from 'react-hot-toast'
import MainLayout from './layouts/MainLayout.jsx'
import AuthLayout from './layouts/AuthLayout.jsx'
import Login from './pages/auth/Login.jsx'
import Dashboard from './pages/dashboard/Dashboard.jsx'
import EmployeeList from './pages/employees/EmployeeList.jsx'
import EmployeeDetail from './pages/employees/EmployeeDetail.jsx'
import EmployeeCreate from './pages/employees/EmployeeCreate.jsx'
import EmployeeEdit from './pages/employees/EmployeeEdit.jsx'
import AttendanceList from './pages/attendance/AttendanceList.jsx'
import AttendanceSummary from './pages/attendance/AttendanceSummary.jsx'
import DepartmentList from './pages/departments/DepartmentList.jsx'
import DepartmentCreate from './pages/departments/DepartmentCreate.jsx'
import DepartmentEdit from './pages/departments/DepartmentEdit.jsx'
import LeaveList from './pages/leaves/LeaveList.jsx'
import LeaveApproval from './pages/leaves/LeaveApproval.jsx'
import LeaveBalance from './pages/leaves/LeaveBalance.jsx'
import ProfileSettings from './pages/settings/ProfileSettings.jsx'
import SystemSettings from './pages/settings/SystemSettings.jsx'
import AttendanceReport from './pages/reports/AttendanceReport.jsx'
import LeaveReport from './pages/reports/LeaveReport.jsx'
import PrivateRoute from './components/common/PrivateRoute.jsx'

function App() {
  return (
    <BrowserRouter>
      <ThemeProvider>
        <NotificationProvider>
          <AuthProvider>
            <Toaster position="top-right" />
            <Routes>
              {/* Public Routes */}
              <Route element={<AuthLayout />}>
                <Route path="/login" element={<Login />} />
              </Route>

              {/* Protected Routes */}
              <Route element={<PrivateRoute />}>
                <Route element={<MainLayout />}>
                  <Route path="/" element={<Navigate to="/dashboard" replace />} />
                  <Route path="/dashboard" element={<Dashboard />} />
                  
                  {/* Employees */}
                  <Route path="/employees" element={<EmployeeList />} />
                  <Route path="/employees/create" element={<EmployeeCreate />} />
                  <Route path="/employees/:id" element={<EmployeeDetail />} />
                  <Route path="/employees/:id/edit" element={<EmployeeEdit />} />
                  
                  {/* Attendance */}
                  <Route path="/attendance" element={<AttendanceList />} />
                  <Route path="/attendance/summary" element={<AttendanceSummary />} />
                  
                  {/* Departments */}
                  <Route path="/departments" element={<DepartmentList />} />
                  <Route path="/departments/create" element={<DepartmentCreate />} />
                  <Route path="/departments/:id/edit" element={<DepartmentEdit />} />
                  
                  {/* Leaves */}
                  <Route path="/leaves" element={<LeaveList />} />
                  <Route path="/leaves/approval" element={<LeaveApproval />} />
                  <Route path="/leaves/balance" element={<LeaveBalance />} />
                  
                  {/* Reports */}
                  <Route path="/reports/attendance" element={<AttendanceReport />} />
                  <Route path="/reports/leaves" element={<LeaveReport />} />
                  
                  {/* Settings */}
                  <Route path="/settings/profile" element={<ProfileSettings />} />
                  <Route path="/settings/system" element={<SystemSettings />} />
                </Route>
              </Route>

              {/* 404 */}
              <Route path="*" element={<Navigate to="/dashboard" replace />} />
            </Routes>
          </AuthProvider>
        </NotificationProvider>
      </ThemeProvider>
    </BrowserRouter>
  )
}

export default App