import { NavLink } from 'react-router-dom'
import { 
  LayoutDashboard, 
  Users, 
  CalendarCheck, 
  Building2, 
  CalendarClock, 
  FileText, 
  Settings,
  LogOut
} from 'lucide-react'
import { useAuth } from '../../hooks/useAuth.js'

const Sidebar = () => {
  const { logout } = useAuth()

  const navigation = [
    { name: 'Dashboard', to: '/dashboard', icon: LayoutDashboard },
    { name: 'Employees', to: '/employees', icon: Users },
    { name: 'Attendance', to: '/attendance', icon: CalendarCheck },
    { name: 'Departments', to: '/departments', icon: Building2 },
    { name: 'Leaves', to: '/leaves', icon: CalendarClock },
    { name: 'Reports', to: '/reports/attendance', icon: FileText },
    { name: 'Settings', to: '/settings/profile', icon: Settings },
  ]

  return (
    <div className="fixed inset-y-0 left-0 z-50 hidden w-72 flex-col bg-white shadow-lg lg:flex">
      <div className="flex h-16 items-center justify-center border-b">
        <h1 className="text-xl font-bold text-blue-600">HRIS Admin</h1>
      </div>
      
      <nav className="flex-1 space-y-1 px-4 py-4">
        {navigation.map((item) => {
          const Icon = item.icon
          return (
            <NavLink
              key={item.name}
              to={item.to}
              className={({ isActive }) =>
                `flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
                  isActive
                    ? 'bg-blue-50 text-blue-600'
                    : 'text-gray-700 hover:bg-gray-100'
                }`
              }
            >
              <Icon className="h-5 w-5" />
              {item.name}
            </NavLink>
          )
        })}
      </nav>

      <div className="border-t p-4">
        <button
          onClick={logout}
          className="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-red-600 hover:bg-red-50"
        >
          <LogOut className="h-5 w-5" />
          Logout
        </button>
      </div>
    </div>
  )
}

export default Sidebar