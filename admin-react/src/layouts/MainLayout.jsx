import { Outlet } from 'react-router-dom'
import Sidebar from './components/Sidebar.jsx'
import Header from './components/Header.jsx'

const MainLayout = () => {
  return (
    <div className="min-h-screen bg-gray-50">
      <Sidebar />
      <div className="lg:pl-72">
        <Header />
        <main className="py-10">
          <div className="px-4 sm:px-6 lg:px-8">
            <Outlet />
          </div>
        </main>
      </div>
    </div>
  )
}

export default MainLayout