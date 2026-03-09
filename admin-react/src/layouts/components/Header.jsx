import { useState } from 'react'
import { Menu, Bell, User, Moon, Sun } from 'lucide-react'
import { useAuth } from '../../hooks/useAuth.js'
import { useTheme } from '../../hooks/useTheme.js'

const Header = () => {
  const { user } = useAuth()
  const { theme, toggleTheme } = useTheme()
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)

  return (
    <header className="sticky top-0 z-40 flex h-16 items-center gap-x-4 border-b bg-white px-4 shadow-sm lg:px-8">
      <button
        type="button"
        className="lg:hidden"
        onClick={() => setMobileMenuOpen(true)}
      >
        <Menu className="h-6 w-6" />
      </button>

      <div className="flex flex-1 items-center justify-end gap-x-4">
        <button
          onClick={toggleTheme}
          className="rounded-full p-2 hover:bg-gray-100"
        >
          {theme === 'light' ? (
            <Moon className="h-5 w-5" />
          ) : (
            <Sun className="h-5 w-5" />
          )}
        </button>

        <button className="rounded-full p-2 hover:bg-gray-100">
          <Bell className="h-5 w-5" />
        </button>

        <div className="flex items-center gap-3">
          <div className="h-8 w-8 rounded-full bg-blue-500 flex items-center justify-center text-white">
            <User className="h-4 w-4" />
          </div>
          <div className="hidden lg:block">
            <p className="text-sm font-medium">{user?.name}</p>
            <p className="text-xs text-gray-500">{user?.position}</p>
          </div>
        </div>
      </div>
    </header>
  )
}

export default Header