import React from 'react';

const Flashcards = () => {
  return (
    <div>
      <h1 className="text-3xl font-bold text-gray-900 mb-6">Flashcards</h1>
      
      <div className="bg-white rounded-lg shadow p-8">
        <div className="text-center py-12">
          <span className="text-6xl mb-4 block">📇</span>
          <h2 className="text-2xl font-semibold text-gray-700 mb-2">
            Flashcards Module
          </h2>
          <p className="text-gray-600 mb-6">
            This feature is coming soon! You'll be able to create, study, and manage your flashcards here.
          </p>
          <div className="flex justify-center space-x-4">
            <button className="px-6 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors">
              Create Flashcard Set
            </button>
            <button className="px-6 py-3 border border-gray-300 text-gray-700 rounded-md hover:bg-gray-50 transition-colors">
              Browse Library
            </button>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-6">
        <div className="bg-white rounded-lg shadow p-6">
          <h3 className="text-lg font-semibold mb-2">Recent Sets</h3>
          <p className="text-gray-600 text-sm">No flashcard sets yet</p>
        </div>
        
        <div className="bg-white rounded-lg shadow p-6">
          <h3 className="text-lg font-semibold mb-2">Study Progress</h3>
          <p className="text-gray-600 text-sm">Start studying to track progress</p>
        </div>
        
        <div className="bg-white rounded-lg shadow p-6">
          <h3 className="text-lg font-semibold mb-2">Quick Stats</h3>
          <div className="space-y-2 text-sm">
            <div className="flex justify-between">
              <span className="text-gray-600">Total Cards:</span>
              <span className="font-medium">0</span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">Mastered:</span>
              <span className="font-medium">0</span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">In Progress:</span>
              <span className="font-medium">0</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Flashcards;