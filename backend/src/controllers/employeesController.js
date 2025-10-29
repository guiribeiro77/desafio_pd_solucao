import { createEmployee, getAllEmployees } from '../models/employeesModel.js';

export const addEmployee = (req, res) => {
  const { name , estimatedHours, squadId} = req.body;

  if (!name || name.trim() === '') {
    return res.status(400).json({ message: 'O campo "name" é obrigatório.' });
  } else if(estimatedHours == null || isNaN(estimatedHours) || estimatedHours <= 0) {
    return res.status(400).json({ message: 'O campo "estimatedHours" deve ser um número positivo.' });
  }

  createEmployee(name, estimatedHours, squadId, (err, newEmployee) => {
    if (err) {
      console.error('Erro ao criar funcionario:', err);
      return res.status(500).json({ message: 'Erro ao criar funcionario.' });
    }
    res.status(201).json(newEmployee);
  });
};

export const listEmployees = (req, res) => {
  getAllEmployees((err, employees) => {
    if (err) return res.status(500).json({ message: 'Erro ao listar funcionarios.' });
    res.json(employees);
  });
};
