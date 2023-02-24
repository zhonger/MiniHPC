CREATE DATABASE IF NOT EXISTS `slurm_jobcomp_db`;
GRANT ALL ON `slurm_jobcomp_db`.* TO 'hpc'@'%';
CREATE DATABASE IF NOT EXISTS `slurm_acct_db`;
GRANT ALL ON `slurm_acct_db`.* TO 'hpc'@'%';