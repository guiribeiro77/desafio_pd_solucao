import { createSquad, getAllSquads } from '../models/squadModel.js';

export const addSquad = (req, res) => {
  const { name } = req.body;

  if (!name) {
    return res.status(400).json({ error: 'Informe o nome da squad' });
  }

  createSquad(name, (err, squad) => {
    if (err) {
      console.error('Erro ao criar squad:', err);
      return res.status(500).json({ error: 'Erro ao criar squad' });
    }
    res.status(201).json(squad);
  });
};

export const listSquads = (req, res) => {
  getAllSquads((err, squads) => {
    if (err) {
      console.error('Erro ao listar squads:', err);
      return res.status(500).json({ error: 'Erro ao listar squads' });
    }
    res.json(squads);
  });
};
