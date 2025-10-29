import db from '../config/db.js';

export const createSquad = (name, callback) => {
  const sql = 'INSERT INTO squads (name) VALUES (?)';
  db.query(sql, [name], (err, result) => {
    if (err) return callback(err, null);
    callback(null, { id: result.insertId, name });
  });
};

export const getAllSquads = (callback) => {
  const sql = 'SELECT * FROM squads';
  db.query(sql, (err, results) => {
    if (err) return callback(err, null);
    callback(null, results);
  });
};
