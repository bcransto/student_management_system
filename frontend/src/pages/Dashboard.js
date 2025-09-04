import React from 'react';
import { useAuth } from '../context/AuthContext';

const Dashboard = () => {
  const { user } = useAuth();

  return (
    <div>
      <h1 className="text-3xl font-bold text-gray-900 mb-6">Dashboard</h1>
      
      <div className="bg-white rounded-lg shadow p-6 mb-6">
        <h2 className="text-xl font-semibold mb-4">Welcome back, {user?.name || user?.email}!</h2>
        <p className="text-gray-600">
          You're successfully logged into the Student Management System.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold">Profile</h3>
            <span className="text-3xl">👤</span>
          </div>
          <p className="text-gray-600 text-sm">
            View and edit your personal information
          </p>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold">Flashcards</h3>
            <span className="text-3xl">📇</span>
          </div>
          <p className="text-gray-600 text-sm">
            Study with interactive flashcards
          </p>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold">Progress</h3>
            <span className="text-3xl">📊</span>
          </div>
          <p className="text-gray-600 text-sm">
            Track your learning progress
          </p>
        </div>
      </div>

      <div className="mt-8 bg-blue-50 rounded-lg p-6">
        <h3 className="text-lg font-semibold text-blue-900 mb-2">Quick Stats</h3>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-4">
          <div className="text-center">
            <p className="text-2xl font-bold text-blue-600">0</p>
            <p className="text-sm text-gray-600">Flashcards Created</p>
          </div>
          <div className="text-center">
            <p className="text-2xl font-bold text-blue-600">0</p>
            <p className="text-sm text-gray-600">Study Sessions</p>
          </div>
          <div className="text-center">
            <p className="text-2xl font-bold text-blue-600">0%</p>
            <p className="text-sm text-gray-600">Completion Rate</p>
          </div>
          <div className="text-center">
            <p className="text-2xl font-bold text-blue-600">0</p>
            <p className="text-sm text-gray-600">Days Active</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;