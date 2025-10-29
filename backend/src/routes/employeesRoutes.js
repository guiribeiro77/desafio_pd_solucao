import express from 'express';
import { addEmployee, listEmployees} from '../controllers/employeesController.js';

const router = express.Router();

router.post('/', addEmployee);   // Cadastrar funcionario
router.get('/', listEmployees);  // Listar funcionarios

export default router;
