import { useState } from 'react'
import { Bell, Moon, Sun, Globe, Shield } from 'lucide-react'
import { useTheme } from '../../hooks/useTheme.js'
import toast from 'react-hot-toast'

const SystemSettings = () => {
  const { theme, toggleTheme } = useTheme()
  const [settings, setSettings] = useState({
    notifications: true,
    emailAlerts: true,
    language: 'en',
    timezone: 'Asia/Jakarta'
  })

  const handleSave = () => {
    toast.success('Settings saved successfully')
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold text-gray-900">System Settings</h1>

      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="space-y-6">
          {/* Appearance */}
          <div>
            <h2 className="text-lg font-semibold mb-4 flex items-center gap-2">
              <Sun className="h-5 w-5" />
              Appearance
            </h2>
            <div className="bg-gray-50 rounded-lg p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Theme</p>
                  <p className="text-sm text-gray-500">Switch between light and dark mode</p>
                </div>
                <button
                  onClick={toggleTheme}
                  className="px-4 py-2 bg-gray-200 rounded-lg hover:bg-gray-300 flex items-center gap-2"
                >
                  {theme === 'light' ? (
                    <>
                      <Moon className="h-4 w-4" />
                      Switch to Dark
                    </>
                  ) : (
                    <>
                      <Sun className="h-4 w-4" />
                      Switch to Light
                    </>
                  )}
                </button>
              </div>
            </div>
          </div>

          {/* Notifications */}
          <div>
            <h2 className="text-lg font-semibold mb-4 flex items-center gap-2">
              <Bell className="h-5 w-5" />
              Notifications
            </h2>
            <div className="bg-gray-50 rounded-lg p-4 space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Push Notifications</p>
                  <p className="text-sm text-gray-500">Receive notifications about leaves and attendance</p>
                </div>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input
                    type="checkbox"
                    checked={settings.notifications}
                    onChange={(e) => setSettings({ ...settings, notifications: e.target.checked })}
                    className="sr-only peer"
                  />
                  <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-500"></div>
                </label>
              </div>

              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Email Alerts</p>
                  <p className="text-sm text-gray-500">Receive email notifications</p>
                </div>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input
                    type="checkbox"
                    checked={settings.emailAlerts}
                    onChange={(e) => setSettings({ ...settings, emailAlerts: e.target.checked })}
                    className="sr-only peer"
                  />
                  <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-500"></div>
                </label>
              </div>
            </div>
          </div>

          {/* Localization */}
          <div>
            <h2 className="text-lg font-semibold mb-4 flex items-center gap-2">
              <Globe className="h-5 w-5" />
              Localization
            </h2>
            <div className="bg-gray-50 rounded-lg p-4 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Language
                </label>
                <select
                  value={settings.language}
                  onChange={(e) => setSettings({ ...settings, language: e.target.value })}
                  className="w-full md:w-64 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  <option value="en">English</option>
                  <option value="id">Indonesian</option>
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Timezone
                </label>
                <select
                  value={settings.timezone}
                  onChange={(e) => setSettings({ ...settings, timezone: e.target.value })}
                  className="w-full md:w-64 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  <option value="Asia/Jakarta">Asia/Jakarta (WIB)</option>
                  <option value="Asia/Makassar">Asia/Makassar (WITA)</option>
                  <option value="Asia/Jayapura">Asia/Jayapura (WIT)</option>
                </select>
              </div>
            </div>
          </div>

          {/* Security */}
          <div>
            <h2 className="text-lg font-semibold mb-4 flex items-center gap-2">
              <Shield className="h-5 w-5" />
              Security
            </h2>
            <div className="bg-gray-50 rounded-lg p-4">
              <button className="text-blue-500 hover:text-blue-700 text-sm font-medium">
                Change Password
              </button>
            </div>
          </div>

          {/* Save Button */}
          <div className="flex justify-end pt-4">
            <button
              onClick={handleSave}
              className="px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600"
            >
              Save All Settings
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}

export default SystemSettings