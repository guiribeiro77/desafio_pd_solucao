import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import squadRoutes from './routes/squadRoutes.js';
import employeeRoutes from './routes/employeesRoutes.js';
import reportRoutes from './routes/reportRoutes.js';

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

app.use('/squad', squadRoutes);
app.use('/employee', employeeRoutes);
app.use('/report', reportRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
