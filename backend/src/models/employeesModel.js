import db from '../config/db.js';

export const createEmployee = (name, estimatedHours,squadId, callback) => {
  const sql = 'INSERT INTO employees (name, estimatedHours, squadId) VALUES (?,?,?)';
  db.query(sql, [name, estimatedHours, squadId], (err, result) => {
    if (err) return callback(err, null);
    callback(null, { id: result.insertId, name, estimatedHours, squadId });
  });
};

export const getAllEmployees = (callback) => {
  const sql = 'SELECT * FROM employees';
  db.query(sql, (err, results) => {
    if (err) return callback(err, null);
    callback(null, results);
  });
};
