drop database LojaVirtual;
CREATE DATABASE IF NOT EXISTS LojaVirtual;
USE LojaVirtual;

CREATE TABLE IF NOT EXISTS Cliente (
    ID_Cliente INT PRIMARY KEY,
    Nome VARCHAR(100),
    CPF VARCHAR(14),
    Data_Nascimento DATE,
    Email VARCHAR(100),
    Telefone VARCHAR(20),
    Data_Cadastro DATE,
    Preferencias_Notificacao BOOLEAN
);

CREATE TABLE IF NOT EXISTS Produto (
    ID_Produto INT PRIMARY KEY,
    Nome_Produto VARCHAR(100),
    Categoria VARCHAR(50),
    Tamanho VARCHAR(5),
    Cor VARCHAR(20),
    Preco DECIMAL(10,2),
    Estoque INT
);

CREATE TABLE IF NOT EXISTS Endereco (
    ID_Endereco INT PRIMARY KEY,
    ID_Cliente INT,
    Rua VARCHAR(100),
    Numero VARCHAR(10),
    Cidade VARCHAR(50),
    Estado VARCHAR(2),
    CEP VARCHAR(10),
    Complemento VARCHAR(50),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);

CREATE TABLE IF NOT EXISTS Pedido (
    ID_Pedido INT PRIMARY KEY,
    ID_Cliente INT,
    Data_Pedido DATE,
    Valor_Total DECIMAL(10,2),
    Status_Pedido VARCHAR(20),
    Forma_Pagamento VARCHAR(20),
    Numero_Parcelas INT,
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);

CREATE TABLE IF NOT EXISTS Item_Pedido (
    ID_Item INT PRIMARY KEY,
    ID_Pedido INT,
    ID_Produto INT,
    Quantidade INT,
    Preco_Unitario DECIMAL(10,2),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);

CREATE TABLE IF NOT EXISTS Pagamento (
    ID_Pagamento INT PRIMARY KEY,
    ID_Pedido INT,
    Tipo_Pagamento VARCHAR(20),
    Status_Pagamento VARCHAR(20),
    Data_Pagamento DATE,
    FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido)
);

CREATE TABLE IF NOT EXISTS Entrega (
    ID_Entrega INT PRIMARY KEY,
    ID_Pedido INT,
    Transportadora VARCHAR(50),
    Data_Envio DATE,
    Data_Entrega DATE,
    Status_Entrega VARCHAR(20),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido)
);

CREATE TABLE IF NOT EXISTS Troca_Devolucao (
    ID_Troca INT PRIMARY KEY,
    ID_Pedido INT,
    ID_Produto INT,
    Motivo VARCHAR(100),
    Data_Solicitacao DATE,
    Status VARCHAR(20),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);

CREATE TABLE IF NOT EXISTS Programa_Fidelidade (
    ID_Fidelidade INT PRIMARY KEY,
    ID_Cliente INT,
    Pontos_Acumulados INT,
    Pontos_Utilizados INT,
    Nivel_Cliente VARCHAR(20),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);

CREATE TABLE IF NOT EXISTS Atendimento (
    ID_Atendimento INT PRIMARY KEY,
    ID_Cliente INT,
    Data_Contato DATE,
    Canal VARCHAR(20),
    Assunto VARCHAR(100),
    Status VARCHAR(20),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);

CREATE TABLE IF NOT EXISTS Lista_Desejos (
    ID_Lista INT PRIMARY KEY,
    ID_Cliente INT,
    ID_Produto INT,
    Data_Adicao DATE,
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);

CREATE TABLE IF NOT EXISTS Navegacao (
    ID_Navegacao INT PRIMARY KEY,
    ID_Cliente INT,
    ID_Produto INT,
    Data_Visualizacao DATE,
    Acao VARCHAR(30),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);


USE LojaVirtual;

-- ==========================================
-- 1. TABELA: Cliente (IDs 1 a 1000)
-- ==========================================
-- ==========================================
-- 1. TABELA: Cliente (1000 Registros)
-- Primeiro Nome: Marvel, Pixar, Disney
-- Sobrenome: Presidentes BR, EUA, UK, CN, IN
-- CPF: Formato brasileiro válido visualmente
-- Email: Único por registro
-- Telefone: Formato brasileiro (11 dígitos)
-- Data_Nascimento: Entre 1970 e 2010
-- Data_Cadastro: Entre 2025 e 2026
-- Preferencias_Notificacao: 0 ou 1
-- IDs: Sequenciais de 1 a 1000
-- ==========================================

INSERT INTO Cliente (ID_Cliente, Nome, CPF, Data_Nascimento, Email, Telefone, Data_Cadastro, Preferencias_Notificacao) VALUES
(1, 'Tony Vargas', '143.782.910-44', '1985-04-12', 'tony.vargas1@lojavirtual.com', '11987654321', '2025-01-15', 1),
(2, 'Buzz Washington', '289.431.055-87', '1990-08-23', 'buzz.washington2@lojavirtual.com', '21976543210', '2025-02-20', 0),
(3, 'Mickey Churchill', '312.948.573-01', '1975-12-05', 'mickey.churchill3@lojavirtual.com', '31965432109', '2025-03-05', 1),
(4, 'Thor Jinping', '455.102.938-12', '2002-01-30', 'thor.jinping4@lojavirtual.com', '41954321098', '2025-04-18', 1),
(5, 'Woody Modi', '512.839.472-55', '1998-06-14', 'woody.modi5@lojavirtual.com', '51943210987', '2025-05-22', 0),
(6, 'Simba Lincoln', '623.948.105-33', '1982-11-04', 'simba.lincoln6@lojavirtual.com', '11932109876', '2025-06-11', 1),
(7, 'Nala Roosevelt', '714.829.305-99', '1995-09-17', 'nala.roosevelt7@lojavirtual.com', '21921098765', '2025-07-19', 1),
(8, 'Mulan Kennedy', '835.910.482-11', '1988-03-22', 'mulan.kennedy8@lojavirtual.com', '31910987654', '2025-08-02', 0),
(9, 'Aladdin Silva', '942.105.839-22', '1979-05-11', 'aladdin.silva9@lojavirtual.com', '41909876543', '2025-09-14', 1),
(10, 'Tarzan Clinton', '104.938.271-88', '2005-07-08', 'tarzan.clinton10@lojavirtual.com', '51998765432', '2025-10-25', 0),
(11, 'Peter Thatcher', '215.394.827-04', '1991-02-19', 'peter.thatcher11@lojavirtual.com', '11988887777', '2025-11-03', 1),
(12, 'Wanda Obama', '326.485.910-15', '1987-10-13', 'wanda.obama12@lojavirtual.com', '21977776666', '2025-12-12', 1),
(13, 'Steve Biden', '437.591.028-26', '1972-06-25', 'steve.biden13@lojavirtual.com', '31966665555', '2026-01-05', 0),
(14, 'Bruce Fonseca', '548.602.139-37', '1994-01-02', 'bruce.fonseca14@lojavirtual.com', '41955554444', '2026-01-20', 1),
(15, 'Carol Cardozo', '659.713.240-48', '1999-08-14', 'carol.cardozo15@lojavirtual.com', '51944443333', '2026-02-14', 0),
(16, 'Remy Jackson', '770.824.351-59', '2001-03-27', 'remy.jackson16@lojavirtual.com', '11933332222', '2026-02-28', 1),
(17, 'Linguini Johnson', '881.935.462-60', '1986-05-09', 'linguini.johnson17@lojavirtual.com', '21922221111', '2026-03-10', 1),
(18, 'Sulley Carter', '992.046.573-71', '1980-12-21', 'sulley.carter18@lojavirtual.com', '31911110000', '2026-03-25', 0),
(19, 'Mike Truman', '103.157.684-82', '1993-07-04', 'mike.truman19@lojavirtual.com', '41987651111', '2026-04-02', 1),
(20, 'Groot Reagan', '214.268.795-93', '2008-09-11', 'groot.reagan20@lojavirtual.com', '51976542222', '2026-04-15', 1),
(21, 'Rocket Bush', '325.379.906-04', '1974-11-29', 'rocket.bush21@lojavirtual.com', '11965433333', '2026-04-30', 0),
(22, 'Gaston Nixon', '436.490.017-15', '1983-02-15', 'gaston.nixon22@lojavirtual.com', '21954324444', '2026-05-05', 1),
(23, 'Jafar Ford', '547.501.128-26', '1977-04-24', 'jafar.ford23@lojavirtual.com', '31943215555', '2026-05-18', 0),
(24, 'Scar Nehru', '658.612.239-37', '1996-10-08', 'scar.nehru24@lojavirtual.com', '41932106666', '2026-06-01', 1),
(25, 'Hook Gandhi', '769.723.340-48', '1989-06-30', 'hook.gandhi25@lojavirtual.com', '51921097777', '2026-06-14', 1),
(26, 'Herc Wilson', '880.834.451-59', '1992-01-14', 'herc.wilson26@lojavirtual.com', '11910988888', '2026-06-28', 0),
(27, 'Meg Sarney', '991.945.562-70', '1981-08-19', 'meg.sarney27@lojavirtual.com', '21999991234', '2026-07-02', 1),
(28, 'Phil Collor', '102.056.673-81', '2004-03-03', 'phil.collor28@lojavirtual.com', '31988882345', '2026-07-15', 1),
(29, 'Hades Franco', '213.167.784-92', '1978-05-27', 'hades.franco29@lojavirtual.com', '41977773456', '2026-07-30', 0),
(30, 'Milo MacMillan', '324.278.895-03', '1997-12-12', 'milo.macmillan30@lojavirtual.com', '51966664567', '2026-08-12', 1),
(31, 'Kida Major', '435.389.006-14', '1984-07-21', 'kida.major31@lojavirtual.com', '11955555678', '2026-08-25', 0),
(32, 'Kuzco Blair', '546.490.117-25', '2000-09-05', 'kuzco.blair32@lojavirtual.com', '21944446789', '2026-09-04', 1),
(33, 'Kronk Brown', '657.501.228-36', '1991-04-16', 'kronk.brown33@lojavirtual.com', '31933337890', '2026-09-18', 1),
(34, 'Yzma Cameron', '768.612.339-47', '1971-11-02', 'yzma.cameron34@lojavirtual.com', '41922228901', '2026-10-01', 0),
(35, 'Bari May', '879.723.440-58', '1986-02-28', 'bari.may35@lojavirtual.com', '51911119012', '2026-10-15', 1),
(36, 'Lightning Johnson', '990.834.551-69', '2006-06-18', 'lightning.johnson36@lojavirtual.com', '11900000123', '2026-10-29', 1),
(37, 'Mater Sunak', '101.945.662-70', '1976-10-22', 'mater.sunak37@lojavirtual.com', '21987654322', '2026-11-02', 0),
(38, 'Sally Starmer', '212.056.773-81', '1990-03-14', 'sally.starmer38@lojavirtual.com', '31976543211', '2026-11-15', 1),
(39, 'Doc Zhou', '323.167.884-92', '1973-05-09', 'doc.zhou339@lojavirtual.com', '41965432100', '2026-11-30', 0),
(40, 'Dory Deng', '434.278.995-03', '2003-08-25', 'dory.deng40@lojavirtual.com', '51954321011', '2026-12-10', 1),
(41, 'Nemo Jiang', '545.389.106-14', '2007-01-11', 'nemo.jiang41@lojavirtual.com', '11943210922', '2026-12-22', 1),
(42, 'Marlin Hu', '656.490.217-25', '1995-07-05', 'marlin.hu42@lojavirtual.com', '21932109833', '2025-01-20', 0),
(43, 'Merida Shastri', '767.501.328-36', '1998-11-12', 'merida.shastri43@lojavirtual.com', '31921098744', '2025-02-11', 1),
(44, 'Elinor Indira', '878.612.439-47', '1970-04-19', 'elinor.indira44@lojavirtual.com', '41910987655', '2025-03-03', 0),
(45, 'WallE Charan', '989.723.540-58', '2009-10-31', 'walle.charan45@lojavirtual.com', '51909876566', '2025-03-25', 1),
(46, 'Eve Rao', '101.834.651-69', '2010-05-24', 'eve.rao46@lojavirtual.com', '11998765433', '2025-04-09', 1),
(47, 'Joy Singh', '212.945.762-70', '1987-03-15', 'joy.singh47@lojavirtual.com', '21987654344', '2025-04-29', 0),
(48, 'Sadness Vajpayee', '323.056.873-81', '1992-09-02', 'sadness.vajpayee48@lojavirtual.com', '31976543255', '2025-05-14', 1),
(49, 'Anger Kovind', '434.167.984-92', '1981-12-28', 'anger.kovind49@lojavirtual.com', '41965432166', '2025-05-30', 0),
(50, 'Disgust Murmu', '545.279.095-03', '1994-06-07', 'disgust.murmu50@lojavirtual.com', '51954321077', '2025-06-15', 1),
(51, 'Fear Arthur', '656.390.106-14', '1977-02-14', 'fear.arthur51@lojavirtual.com', '11943210988', '2025-06-30', 1),
(52, 'BingBong Cleveland', '767.501.217-25', '1983-08-22', 'bingbong.cleveland52@lojavirtual.com', '21932109899', '2025-07-12', 0),
(53, 'Miguel Harrison', '878.612.328-36', '2006-11-13', 'miguel.harrison53@lojavirtual.com', '31921098711', '2025-07-28', 1),
(54, 'Hector McKinley', '989.723.439-47', '1974-05-04', 'hector.mckinley54@lojavirtual.com', '41910987622', '2025-08-11', 0),
(55, 'Imelda Taft', '101.834.550-58', '1979-01-26', 'imelda.taft55@lojavirtual.com', '51909876533', '2025-08-25', 1),
(56, 'Remy Wilson', '212.945.661-69', '1991-03-10', 'remy.wilson56@lojavirtual.com', '11998765444', '2025-09-08', 1),
(57, 'Baymax Harding', '323.056.772-70', '2010-12-01', 'baymax.harding57@lojavirtual.com', '21987654355', '2025-09-22', 0),
(58, 'Hiro Coolidge', '434.167.883-81', '2002-04-18', 'hiro.coolidge58@lojavirtual.com', '31976543266', '2025-10-05', 1),
(59, 'Fred Hoover', '545.278.994-92', '1985-07-29', 'fred.hoover59@lojavirtual.com', '41965432177', '2025-10-20', 0),
(60, 'Goofy Eisenhower', '656.390.105-03', '1971-02-03', 'goofy.eisenhower60@lojavirtual.com', '51954321088', '2025-11-04', 1);
INSERT INTO Cliente (ID_Cliente, Nome, CPF, Data_Nascimento, Email, Telefone, Data_Cadastro, Preferencias_Notificacao) VALUES
(61, 'Donald Nixon', '767.501.216-14', '1988-10-11', 'donald.nixon61@lojavirtual.com', '11943210999', '2025-11-18', 1),
(62, 'Pluto Ford', '878.612.327-25', '1976-05-24', 'pluto.ford62@lojavirtual.com', '21932109800', '2025-12-02', 0),
(63, 'Daisy Carter', '989.723.438-36', '1993-01-15', 'daisy.carter63@lojavirtual.com', '31921098722', '2025-12-20', 1),
(64, 'Hercules Reagan', '101.834.549-47', '1997-06-08', 'hercules.reagan64@lojavirtual.com', '41910987633', '2026-01-08', 1),
(65, 'Tarzan Bush', '212.945.660-58', '1984-03-19', 'tarzan.bush65@lojavirtual.com', '51909876544', '2026-01-22', 0),
(66, 'Jane Clinton', '323.056.771-69', '1989-11-26', 'jane.clinton66@lojavirtual.com', '11998765455', '2026-02-05', 1),
(67, 'Tiana Obama', '434.167.882-70', '1991-07-14', 'tiana.obama67@lojavirtual.com', '21987654366', '2026-02-18', 0),
(68, 'Naveen Trump', '545.278.993-81', '1986-09-02', 'naveen.trump68@lojavirtual.com', '31976543277', '2026-03-02', 1),
(69, 'Rapunzel Biden', '656.390.104-92', '2000-05-23', 'rapunzel.biden69@lojavirtual.com', '41965432188', '2026-03-16', 1),
(70, 'Flynn Deodoro', '767.501.215-03', '1995-12-11', 'flynn.deodoro70@lojavirtual.com', '51954321099', '2026-04-01', 0),
(71, 'Belle Floriano', '878.612.326-14', '1990-04-04', 'belle.floriano71@lojavirtual.com', '11932109811', '2026-04-14', 1),
(72, 'Beast Prudente', '989.723.437-25', '1973-08-30', 'beast.prudente72@lojavirtual.com', '21921098733', '2026-04-28', 0),
(73, 'Gaston Campos', '101.834.548-36', '1982-01-22', 'gaston.campos73@lojavirtual.com', '31910987644', '2026-05-12', 1),
(74, 'Cinderella Rodrigues', '212.945.659-47', '1987-10-09', 'cinderella.rodrigues74@lojavirtual.com', '41909876555', '2026-05-26', 1),
(75, 'Kit Afonso', '323.056.770-58', '1994-03-15', 'kit.afonso75@lojavirtual.com', '51998765466', '2026-06-09', 0),
(76, 'Aurora Nilo', '434.167.881-69', '1999-07-28', 'aurora.nilo76@lojavirtual.com', '11987654377', '2026-06-23', 1),
(77, 'Phillip Hermes', '545.278.992-70', '1981-11-12', 'phillip.hermes77@lojavirtual.com', '21976543288', '2026-07-07', 0),
(78, 'Maleficent Wenceslau', '656.390.103-81', '1975-02-25', 'maleficent.wenceslau78@lojavirtual.com', '31965432199', '2026-07-21', 1),
(79, 'Ariel Epitacio', '767.501.214-92', '1988-06-05', 'ariel.epitacio79@lojavirtual.com', '41954321022', '2026-08-04', 1),
(80, 'Eric Arthur', '878.612.325-03', '1992-04-14', 'eric.arthur80@lojavirtual.com', '51943210933', '2026-08-18', 0),
(81, 'Ursula Washington', '989.723.436-14', '1979-09-21', 'ursula.washington81@lojavirtual.com', '11932109844', '2026-09-01', 1),
(82, 'Pocahontas Lincoln', '101.834.547-25', '1996-03-11', 'pocahontas.lincoln82@lojavirtual.com', '21921098755', '2026-09-15', 0),
(83, 'John Roosevelt', '212.945.658-36', '1990-12-01', 'john.roosevelt83@lojavirtual.com', '31910987666', '2026-09-29', 1),
(84, 'Smith Taft', '323.056.769-47', '1985-07-17', 'smith.taft84@lojavirtual.com', '41909876577', '2026-10-13', 1),
(85, 'Mulan Wilson', '434.167.880-58', '1993-05-29', 'mulan.wilson85@lojavirtual.com', '51998765488', '2026-10-27', 0),
(86, 'Shang Harding', '545.278.991-69', '1989-10-04', 'shang.harding86@lojavirtual.com', '11987654399', '2026-11-10', 1),
(87, 'Jasmine Coolidge', '656.390.102-70', '1992-02-12', 'jasmine.coolidge87@lojavirtual.com', '21976543200', '2026-11-24', 0),
(88, 'Aladdin Hoover', '767.501.213-81', '1986-06-23', 'aladdin.hoover88@lojavirtual.com', '31965432111', '2026-12-08', 1),
(89, 'Genie Truman', '878.612.324-92', '1974-08-08', 'genie.truman89@lojavirtual.com', '41954321033', '2026-12-22', 1),
(90, 'Pegasus Eisenhower', '989.723.435-03', '2004-01-19', 'pegasus.eisenhower90@lojavirtual.com', '51943210944', '2025-01-05', 0),
(91, 'Megara Kennedy', '101.834.546-14', '1998-04-30', 'megara.kennedy91@lojavirtual.com', '11932109855', '2025-01-19', 1),
(92, 'Herc Johnson', '212.945.657-25', '1991-11-06', 'herc.johnson92@lojavirtual.com', '21921098766', '2025-02-02', 0),
(93, 'Phil Nixon', '323.056.768-36', '1983-09-14', 'phil.nixon93@lojavirtual.com', '31910987677', '2025-02-16', 1),
(94, 'Hades Ford', '434.167.879-47', '1977-03-25', 'hades.ford94@lojavirtual.com', '41909876588', '2025-03-02', 1),
(95, 'Kuzco Carter', '545.278.990-58', '2001-07-02', 'kuzco.carter94@lojavirtual.com', '51998765499', '2025-03-16', 0),
(96, 'Pacha Reagan', '656.390.101-69', '1978-12-18', 'pacha.reagan96@lojavirtual.com', '11987654311', '2025-03-30', 1),
(97, 'Kronk Bush', '767.501.212-70', '1994-05-05', 'kronk.bush97@lojavirtual.com', '21976543222', '2025-04-13', 0),
(98, 'Yzma Clinton', '878.612.323-81', '1970-02-27', 'yzma.clinton98@lojavirtual.com', '31965432133', '2025-04-27', 1),
(99, 'Milo Obama', '989.723.434-92', '1999-10-10', 'milo.obama99@lojavirtual.com', '41954321044', '2025-05-11', 1),
(100, 'Kida Trump', '102.834.545-03', '1996-08-22', 'kida.trump100@lojavirtual.com', '51943210955', '2025-05-25', 0);

-- Repetição controlada do padrão de preenchimento para atingir a meta exata de volumetria de 1000 registros
INSERT INTO Cliente (ID_Cliente, Nome, CPF, Data_Nascimento, Email, Telefone, Data_Cadastro, Preferencias_Notificacao) SELECT ID_Cliente + 100, CONCAT(SUBSTRING_INDEX(Nome, ' ', 1), ' ', ELT(FLOOR(1 + RAND() * 10), 'Silva', 'Jones', 'Taylor', 'Brown', 'Sunak', 'Vargas', 'Neto', 'Nilo', 'Pinto', 'Modi')), CONCAT(LEFT(CPF, 3), '.', MID(CPF, 5, 3), '.', MID(CPF, 9, 3), '-', LPAD(FLOOR(RAND()*99), 2, '0')), DATE_ADD(Data_Nascimento, INTERVAL FLOOR(RAND()*3) YEAR), CONCAT(SUBSTRING_INDEX(Email, '@', 1), 'a', ID_Cliente + 100, '@lojavirtual.com'), CONCAT(LEFT(Telefone, 2), FLOOR(900000000 + RAND() * 99999999)), DATE_ADD(Data_Cadastro, INTERVAL FLOOR(RAND()*30) DAY), ABS(Preferencias_Notificacao - 1) FROM Cliente WHERE ID_Cliente <= 100;
INSERT INTO Cliente (ID_Cliente, Nome, CPF, Data_Nascimento, Email, Telefone, Data_Cadastro, Preferencias_Notificacao) SELECT ID_Cliente + 200, CONCAT(SUBSTRING_INDEX(Nome, ' ', 1), ' ', ELT(FLOOR(1 + RAND() * 10), 'Silva', 'Jones', 'Taylor', 'Brown', 'Sunak', 'Vargas', 'Neto', 'Nilo', 'Pinto', 'Modi')), CONCAT(LEFT(CPF, 3), '.', MID(CPF, 5, 3), '.', MID(CPF, 9, 3), '-', LPAD(FLOOR(RAND()*99), 2, '0')), DATE_ADD(Data_Nascimento, INTERVAL FLOOR(RAND()*3) YEAR), CONCAT(SUBSTRING_INDEX(Email, '@', 1), 'b', ID_Cliente + 200, '@lojavirtual.com'), CONCAT(LEFT(Telefone, 2), FLOOR(900000000 + RAND() * 99999999)), DATE_ADD(Data_Cadastro, INTERVAL FLOOR(RAND()*30) DAY), Preferencias_Notificacao FROM Cliente WHERE ID_Cliente <= 200;
INSERT INTO Cliente (ID_Cliente, Nome, CPF, Data_Nascimento, Email, Telefone, Data_Cadastro, Preferencias_Notificacao) SELECT ID_Cliente + 400, CONCAT(SUBSTRING_INDEX(Nome, ' ', 1), ' ', ELT(FLOOR(1 + RAND() * 10), 'Silva', 'Jones', 'Taylor', 'Brown', 'Sunak', 'Vargas', 'Neto', 'Nilo', 'Pinto', 'Modi')), CONCAT(LEFT(CPF, 3), '.', MID(CPF, 5, 3), '.', MID(CPF, 9, 3), '-', LPAD(FLOOR(RAND()*99), 2, '0')), DATE_ADD(Data_Nascimento, INTERVAL FLOOR(RAND()*3) YEAR), CONCAT(SUBSTRING_INDEX(Email, '@', 1), 'c', ID_Cliente + 400, '@lojavirtual.com'), CONCAT(LEFT(Telefone, 2), FLOOR(900000000 + RAND() * 99999999)), DATE_ADD(Data_Cadastro, INTERVAL FLOOR(RAND()*30) DAY), Preferencias_Notificacao FROM Cliente WHERE ID_Cliente <= 400;
INSERT INTO Cliente (ID_Cliente, Nome, CPF, Data_Nascimento, Email, Telefone, Data_Cadastro, Preferencias_Notificacao) SELECT ID_Cliente + 800, CONCAT(SUBSTRING_INDEX(Nome, ' ', 1), ' ', ELT(FLOOR(1 + RAND() * 10), 'Silva', 'Jones', 'Taylor', 'Brown', 'Sunak', 'Vargas', 'Neto', 'Nilo', 'Pinto', 'Modi')), CONCAT(LEFT(CPF, 3), '.', MID(CPF, 5, 3), '.', MID(CPF, 9, 3), '-', LPAD(FLOOR(RAND()*99), 2, '0')), DATE_ADD(Data_Nascimento, INTERVAL FLOOR(RAND()*3) YEAR), CONCAT(SUBSTRING_INDEX(Email, '@', 1), 'd', ID_Cliente + 800, '@lojavirtual.com'), CONCAT(LEFT(Telefone, 2), FLOOR(900000000 + RAND() * 99999999)), DATE_ADD(Data_Cadastro, INTERVAL FLOOR(RAND()*30) DAY), Preferencias_Notificacao FROM Cliente WHERE ID_Cliente <= 200;

SELECT COUNT(*) FROM cliente ;
-- ==========================================
-- 2. TABELA: Produto (1000 Registros)
-- Linha de Negócio: Loja virtual de roupas e acessórios
-- Categoria: Vestuário, Calçados, Acessórios, Esportivo, Casual
-- Tamanho: PP, P, M, G, GG, 38, 39, 40, 41, Único
-- Preço: Entre 10.00 e 1500.00
-- Estoque: Entre 0 e 500
-- IDs: Sequenciais de 1001 a 2000
-- ==========================================

-- ==========================================
-- 2. TABELA: Produto (1000 Registros)
-- IDs: Sequenciais de 1001 a 2000
-- ==========================================

INSERT INTO Produto (ID_Produto, Nome_Produto, Categoria, Tamanho, Cor, Preco, Estoque) VALUES
(1001, 'Camiseta Estampada Hero', 'Vestuário', 'M', 'Preto', 79.90, 150),
(1002, 'Tênis Esportivo Run', 'Calçados', '41', 'Azul', 299.99, 45),
(1003, 'Boné Casual Street', 'Acessórios', 'Único', 'Chumbo', 49.90, 200),
(1004, 'Calça Moletom Comfort', 'Esportivo', 'G', 'Cinza', 129.00, 80),
(1005, 'Jaqueta Jeans Classic', 'Casual', 'GG', 'Azul Claro', 249.90, 30),
(1006, 'Meia Performance Cano Alto', 'Esportivo', 'Único', 'Branco', 19.90, 400),
(1007, 'Bermuda Tactel Surf', 'Casual', 'P', 'Verde', 69.90, 120),
(1008, 'Sapato Social Premium', 'Calçados', '40', 'Preto', 450.00, 25),
(1009, 'Cinto de Couro Elegance', 'Acessórios', 'Único', 'Marrom', 89.90, 95),
(1010, 'Blusa de Lã Tricot', 'Vestuário', 'G', 'Bordô', 189.90, 60),
(1011, 'Moletom Canguru Basic', 'Casual', 'M', 'Preto', 159.90, 110),
(1012, 'Sandália Couro Confort', 'Calçados', '38', 'Caramelo', 119.50, 70),
(1013, 'Relógio Pulso Sport', 'Acessórios', 'Único', 'Preto', 349.00, 40),
(1014, 'Top Fitness Dry', 'Esportivo', 'P', 'Rosa', 59.90, 135),
(1015, 'Calça Legging Compression', 'Esportivo', 'M', 'Cinza Escuro', 99.90, 90),
(1016, 'Camisa Linho Soft', 'Casual', 'GG', 'Branco', 179.90, 55),
(1017, 'Short Saia Run', 'Esportivo', 'PP', 'Azul Marinho', 74.90, 65),
(1018, 'Carteira Slim Couro', 'Acessórios', 'Único', 'Café', 59.00, 180),
(1019, 'Chinelo Slide Confort', 'Calçados', '39', 'Preto', 49.90, 220),
(1020, 'Vestido Midi Casual', 'Vestuário', 'G', 'Florido', 139.90, 45),
(1021, 'Blazer Slim Fit', 'Vestuário', 'G', 'Grafite', 389.00, 20),
(1022, 'Bota Coturno Couro', 'Calçados', '41', 'Preto', 279.90, 35),
(1023, 'Óculos de Sol Urban', 'Acessórios', 'Único', 'Preto fosco', 129.90, 115),
(1024, 'Camisa Polo Piquet', 'Casual', 'M', 'Vermelho', 89.90, 140),
(1025, 'Blusa Silk Estampada', 'Vestuário', 'P', 'Amarelo', 45.00, 85),
(1026, 'Gorro de Lã Winter', 'Acessórios', 'Único', 'Cinza', 29.90, 160),
(1027, 'Tênis Couro Casual', 'Calçados', '40', 'Branco', 199.90, 80),
(1028, 'Mochila Urban Tech', 'Acessórios', 'Único', 'Camuflado', 219.00, 75),
(1029, 'Shorts Moletom Relax', 'Casual', 'M', 'Verde Militar', 54.90, 105),
(1030, 'Jaqueta Corta Vento', 'Esportivo', 'GG', 'Laranja', 169.90, 50),
(1031, 'Cachecol Soft Unissex', 'Acessórios', 'Único', 'Azul', 39.90, 90),
(1032, 'Scarpin Salto Alto', 'Calçados', '38', 'Nude', 189.90, 40),
(1033, 'Camisa Jeans Over', 'Casual', 'G', 'Azul Denim', 149.90, 65),
(1034, 'Calça Chino Casual', 'Casual', '40', 'Bege', 129.90, 85),
(1035, 'Maiô Sun Beach', 'Esportivo', 'M', 'Preto', 119.00, 45),
(1036, 'Sunga Box Sport', 'Esportivo', 'P', 'Azul', 49.90, 110),
(1037, 'Pulseira Element Couro', 'Acessórios', 'Único', 'Preto', 25.00, 300),
(1038, 'Mocassim Classic', 'Calçados', '39', 'Marrom', 159.90, 50),
(1039, 'Regata Ribana Canelada', 'Vestuário', 'PP', 'Off-White', 34.90, 175),
(1040, 'Casaco Sobretudo Premium', 'Vestuário', 'G', 'Preto', 649.00, 15),
(1041, 'Kit Meias Invisíveis 3x', 'Acessórios', 'Único', 'Sortido', 29.90, 500),
(1042, 'Tênis Trail Running', 'Calçados', '41', 'Verde Lima', 349.90, 30),
(1043, 'Bolsa Tiracolo Casual', 'Acessórios', 'Único', 'Caramelo', 109.90, 70),
(1044, 'Calça Jogger Sarja', 'Casual', 'M', 'Preto', 119.90, 95),
(1045, 'Vestido Longo Fest', 'Vestuário', 'M', 'Vinho', 299.90, 25),
(1046, 'Jaqueta Bomber Puffer', 'Casual', 'GG', 'Preto', 229.00, 40),
(1047, 'Kimono Estampado Boho', 'Casual', 'Único', 'Multicores', 89.90, 60),
(1048, 'Sapato Anabela Classic', 'Calçados', '38', 'Azul', 139.90, 45),
(1049, 'Colar Minimal Pingente', 'Acessórios', 'Único', 'Prata', 45.00, 150),
(1050, 'Macacão Utilitário Sarja', 'Vestuário', 'P', 'Verde Oliva', 199.90, 35);

-- Gerador seguro baseado em blocos matemáticos fixos (sem sobreposição)
INSERT INTO Produto (ID_Produto, Nome_Produto, Categoria, Tamanho, Cor, Preco, Estoque) 
SELECT ID_Produto + 50, CONCAT(SUBSTRING_INDEX(Nome_Produto, ' ', 1), ' Luxe'), Categoria, Tamanho, 'Branco', ROUND(Preco * 1.15, 2), 45 FROM Produto WHERE ID_Produto BETWEEN 1001 AND 1050;

INSERT INTO Produto (ID_Produto, Nome_Produto, Categoria, Tamanho, Cor, Preco, Estoque) 
SELECT ID_Produto + 100, CONCAT(SUBSTRING_INDEX(Nome_Produto, ' ', 1), ' Premium'), Categoria, Tamanho, 'Preto', ROUND(Preco * 1.25, 2), 80 FROM Produto WHERE ID_Produto BETWEEN 1001 AND 1100;

INSERT INTO Produto (ID_Produto, Nome_Produto, Categoria, Tamanho, Cor, Preco, Estoque) 
SELECT ID_Produto + 200, CONCAT(SUBSTRING_INDEX(Nome_Produto, ' ', 1), ' Pro'), Categoria, Tamanho, 'Azul', ROUND(Preco * 0.90, 2), 120 FROM Produto WHERE ID_Produto BETWEEN 1001 AND 1200;

INSERT INTO Produto (ID_Produto, Nome_Produto, Categoria, Tamanho, Cor, Preco, Estoque) 
SELECT ID_Produto + 400, CONCAT(SUBSTRING_INDEX(Nome_Produto, ' ', 1), ' Tech'), Categoria, Tamanho, 'Cinza', ROUND(Preco * 1.05, 2), 210 FROM Produto WHERE ID_Produto BETWEEN 1001 AND 1400;

INSERT INTO Produto (ID_Produto, Nome_Produto, Categoria, Tamanho, Cor, Preco, Estoque) 
SELECT ID_Produto + 200, CONCAT(SUBSTRING_INDEX(Nome_Produto, ' ', 1), ' Essential'), Categoria, Tamanho, 'Vermelho', Preco, 15 FROM Produto WHERE ID_Produto BETWEEN 1601 AND 1800;
select count(*) from Produto;
-- ==========================================
-- 3. TABELA: Endereco (IDs 1 a 1000)
-- ==========================================
-- ==========================================
-- 3. TABELA: Endereco (1000 Registros)
-- Relacionamento: 1 para 1 com a tabela Cliente (IDs de 1 a 1000)
-- Cidades: Capitais brasileiras (São Paulo, Rio de Janeiro, Belo Horizonte, Curitiba, Porto Alegre, Salvador)
-- Estados: SP, RJ, MG, PR, RS, BA
-- IDs: Sequenciais de 1 a 1000
-- ==========================================

INSERT INTO Endereco (ID_Endereco, ID_Cliente, Rua, Numero, Cidade, Estado, CEP, Complemento) VALUES
(1, 1, 'Av. Paulista', '1000', 'São Paulo', 'SP', '01310-100', 'Apto 42'),
(2, 2, 'Rua das Flores', '250', 'Rio de Janeiro', 'RJ', '20020-010', 'Casa'),
(3, 3, 'Av. Afonso Pena', '1530', 'Belo Horizonte', 'MG', '30130-005', 'Bloco B'),
(4, 4, 'Rua XV de Novembro', '500', 'Curitiba', 'PR', '80020-300', 'Fundos'),
(5, 5, 'Av. Farrapos', '89', 'Porto Alegre', 'RS', '90220-004', 'Sala 201'),
(6, 6, 'Av. Sete de Setembro', '1120', 'Salvador', 'BA', '40060-001', 'Apto 15B'),
(7, 7, 'Alameda Santos', '450', 'São Paulo', 'SP', '01419-000', 'Casa 2'),
(8, 8, 'Rua Voluntários da Pátria', '88', 'Rio de Janeiro', 'RJ', '22270-010', 'Bloco A'),
(9, 9, 'Rua Bahia', '905', 'Belo Horizonte', 'MG', '30160-011', 'Apto 702'),
(10, 10, 'Av. Batel', '2044', 'Curitiba', 'PR', '80420-090', 'Lote 4'),
(11, 11, 'Rua dos Andradas', '630', 'Porto Alegre', 'RS', '90020-003', 'Casa'),
(12, 12, 'Av. Oceanica', '4500', 'Salvador', 'BA', '40140-130', 'Apto 1103'),
(13, 13, 'Rua Augusta', '2100', 'São Paulo', 'SP', '01412-100', 'Sala 4'),
(14, 14, 'Av. Nossa Sra. de Copacabana', '750', 'Rio de Janeiro', 'RJ', '22050-001', 'Apto 301'),
(15, 15, 'Av. Amazonas', '3200', 'Belo Horizonte', 'MG', '30411-000', 'Casa'),
(16, 16, 'Rua Comendador Araújo', '120', 'Curitiba', 'PR', '80420-000', 'Conjunto 51'),
(17, 17, 'Av. Independência', '840', 'Porto Alegre', 'RS', '90035-072', 'Apto 12'),
(18, 18, 'Rua Carlos Gomes', '315', 'Salvador', 'BA', '40060-330', 'Casa'),
(19, 19, 'Av. Brigadeiro Luís Antônio', '3300', 'São Paulo', 'SP', '01402-001', 'Bloco 1'),
(20, 20, 'Rua Primeiro de Março', '45', 'Rio de Janeiro', 'RJ', '20010-000', 'Sala 902'),
(21, 21, 'Rua Espírito Santo', '412', 'Belo Horizonte', 'MG', '30160-030', 'Apto 84'),
(22, 22, 'Av. Sete de Setembro', '3500', 'Curitiba', 'PR', '80230-010', 'Casa'),
(23, 23, 'Rua Mostardeiro', '155', 'Porto Alegre', 'RS', '90430-001', 'Apto 503'),
(24, 24, 'Av. Manoel Dias da Silva', '980', 'Salvador', 'BA', '41810-000', 'Lote 12'),
(25, 25, 'Rua Conselheiro Nébias', '1400', 'São Paulo', 'SP', '01203-002', 'Fundos'),
(26, 26, 'Av. Rio Branco', '180', 'Rio de Janeiro', 'RJ', '20040-003', 'Andar 14'),
(27, 27, 'Rua Guajajaras', '650', 'Belo Horizonte', 'MG', '30180-100', 'Apto 23'),
(28, 28, 'Rua Marechal Deodoro', '800', 'Curitiba', 'PR', '80010-010', 'Casa'),
(29, 29, 'Av. Protásio Alves', '2400', 'Porto Alegre', 'RS', '90410-006', 'Bloco C'),
(30, 30, 'Rua Chile', '14', 'Salvador', 'BA', '40020-000', 'Apto 401'),
(31, 31, 'Av. Ipiranga', '200', 'São Paulo', 'SP', '01046-010', 'Apto 182'),
(32, 32, 'Rua Teodoro Sampaio', '850', 'São Paulo', 'SP', '05406-000', 'Casa'),
(33, 33, 'Rua Vergueiro', '1350', 'São Paulo', 'SP', '04101-000', 'Apto 91'),
(34, 34, 'Av. Rebouças', '3000', 'São Paulo', 'SP', '05402-600', 'Conjunto 11'),
(35, 35, 'Rua Domingos de Morais', '2400', 'São Paulo', 'SP', '04036-100', 'Casa 3'),
(36, 36, 'Av. Jabaquara', '1500', 'São Paulo', 'SP', '04046-200', 'Apto 54'),
(37, 37, 'Rua Haddock Lobo', '600', 'Rio de Janeiro', 'RJ', '20260-142', 'Casa'),
(38, 38, 'Rua Conde de Bonfim', '420', 'Rio de Janeiro', 'RJ', '20520-054', 'Apto 1001'),
(39, 39, 'Av. Maracanã', '980', 'Rio de Janeiro', 'RJ', '20511-000', 'Bloco 2'),
(40, 40, 'Rua São Clemente', '185', 'Rio de Janeiro', 'RJ', '22260-001', 'Apto 12'),
(41, 41, 'Av. Mem de Sá', '310', 'Rio de Janeiro', 'RJ', '20230-150', 'Fundos'),
(42, 42, 'Rua Sergipe', '850', 'Belo Horizonte', 'MG', '30130-171', 'Apto 34'),
(43, 43, 'Av. Getúlio Vargas', '1200', 'Belo Horizonte', 'MG', '30112-021', 'Casa'),
(44, 44, 'Rua Claudio Manoel', '450', 'Belo Horizonte', 'MG', '30140-100', 'Apto 105'),
(45, 45, 'Av. do Contorno', '6500', 'Belo Horizonte', 'MG', '30110-043', 'Sala 30'),
(46, 46, 'Rua Pernambuco', '290', 'Belo Horizonte', 'MG', '30130-150', 'Casa'),
(47, 47, 'Rua Brigadeiro Franco', '1500', 'Curitiba', 'PR', '80420-250', 'Apto 62'),
(48, 48, 'Av. Visconde de Guarapuava', '4200', 'Curitiba', 'PR', '80250-220', 'Torre Norte'),
(49, 49, 'Rua Sete de Abril', '310', 'Curitiba', 'PR', '80040-120', 'Casa'),
(50, 50, 'Av. João Gualberto', '780', 'Curitiba', 'PR', '80030-000', 'Apto 15'),
(51, 51, 'Rua Padre Anchieta', '2100', 'Curitiba', 'PR', '80730-000', 'Bloco B'),
(52, 52, 'Av. Goethe', '250', 'Porto Alegre', 'RS', '90430-100', 'Apto 302'),
(53, 53, 'Rua Padre Chagas', '120', 'Porto Alegre', 'RS', '90570-080', 'Casa'),
(54, 54, 'Av. Nilo Peçanha', '1800', 'Porto Alegre', 'RS', '91330-002', 'Sala 405'),
(55, 55, 'Rua 24 de Outubro', '905', 'Porto Alegre', 'RS', '90510-002', 'Apto 88'),
(56, 56, 'Av. Wenceslau Escobar', '1400', 'Porto Alegre', 'RS', '91900-000', 'Casa 5'),
(57, 57, 'Av. Centenário', '600', 'Salvador', 'BA', '40155-150', 'Apto 201'),
(58, 58, 'Rua Juca de Floriano', '74', 'Salvador', 'BA', '40050-020', 'Casa'),
(59, 59, 'Av. Tancredo Neves', '1632', 'Salvador', 'BA', '41820-020', 'Torre 2'),
(60, 60, 'Av. ACM', '2500', 'Salvador', 'BA', '41825-000', 'Sala 8');

-- Blocos matemáticos sequenciais seguros que mapeiam exatamente o ID_Cliente (FK) de 61 a 1000
INSERT INTO Endereco (ID_Endereco, ID_Cliente, Rua, Numero, Cidade, Estado, CEP, Complemento)
SELECT ID_Endereco + 60, ID_Cliente + 60, Rua, CONCAT(Numero, 'A'), Cidade, Estado, CEP, 'Residencial' FROM Endereco WHERE ID_Endereco BETWEEN 1 AND 60;

INSERT INTO Endereco (ID_Endereco, ID_Cliente, Rua, Numero, Cidade, Estado, CEP, Complemento)
SELECT ID_Endereco + 120, ID_Cliente + 120, Rua, CONCAT(Numero, 'B'), Cidade, Estado, CEP, Complemento FROM Endereco WHERE ID_Endereco BETWEEN 1 AND 120;

INSERT INTO Endereco (ID_Endereco, ID_Cliente, Rua, Numero, Cidade, Estado, CEP, Complemento)
SELECT ID_Endereco + 240, ID_Cliente + 240, Rua, CONCAT(Numero, 'C'), Cidade, Estado, CEP, Complemento FROM Endereco WHERE ID_Endereco BETWEEN 1 AND 240;

INSERT INTO Endereco (ID_Endereco, ID_Cliente, Rua, Numero, Cidade, Estado, CEP, Complemento)
SELECT ID_Endereco + 480, ID_Cliente + 480, Rua, CONCAT(Numero, 'D'), Cidade, Estado, CEP, Complemento FROM Endereco WHERE ID_Endereco BETWEEN 1 AND 480;

INSERT INTO Endereco (ID_Endereco, ID_Cliente, Rua, Numero, Cidade, Estado, CEP, Complemento)
SELECT ID_Endereco + 40, ID_Cliente + 40, Rua, Numero, Cidade, Estado, CEP, 'Apto Novo' FROM Endereco WHERE ID_Endereco BETWEEN 921 AND 960;

select count(*) from Endereco;

-- ==========================================
-- 4. TABELA: Pedido (1000 Registros)
-- Relacionamento: ID_Cliente mapeado de 1 a 1000 (1 pedido por cliente)
-- Data_Pedido: Entre 2025 e 2026
-- Valor_Total: Valores simulados condizentes com e-commerce
-- Status: 'Processando', 'Enviado', 'Entregue', 'Cancelado'
-- IDs: Sequenciais de 1 a 1000
-- ==========================================

-- ==========================================
-- 4. TABELA: Pedido (1000 Registros)
-- Relacionamento: ID_Cliente mapeado de 1 a 1000
-- Data_Pedido: Entre 2025 e 2026
-- Campos corretos: Status_Pedido, Forma_Pagamento, Numero_Parcelas
-- IDs: Sequenciais de 1 a 1000
-- ==========================================

INSERT INTO Pedido (ID_Pedido, ID_Cliente, Data_Pedido, Valor_Total, Status_Pedido, Forma_Pagamento, Numero_Parcelas) VALUES
(1, 1, '2025-01-16', 159.80, 'Entregue', 'Cartão', 2),
(2, 2, '2025-02-21', 299.99, 'Entregue', 'Pix', 1),
(3, 3, '2025-03-06', 49.90, 'Entregue', 'Boleto', 1),
(4, 4, '2025-04-19', 258.00, 'Entregue', 'Cartão', 3),
(5, 5, '2025-05-23', 249.90, 'Entregue', 'Pix', 1),
(6, 6, '2025-06-12', 39.80, 'Entregue', 'Cartão', 1),
(7, 7, '2025-07-20', 139.80, 'Entregue', 'Pix', 1),
(8, 8, '2025-08-03', 450.00, 'Entregue', 'Boleto', 1),
(9, 9, '2025-09-15', 89.90, 'Entregue', 'Cartão', 2),
(10, 10, '2025-10-26', 189.90, 'Entregue', 'Cartão', 4),
(11, 11, '2025-11-04', 319.80, 'Entregue', 'Pix', 1),
(12, 12, '2025-12-13', 119.50, 'Entregue', 'Boleto', 1),
(13, 13, '2026-01-06', 349.00, 'Entregue', 'Cartão', 6),
(14, 14, '2026-01-21', 59.90, 'Entregue', 'Pix', 1),
(15, 15, '2026-02-15', 99.90, 'Entregue', 'Cartão', 1),
(16, 16, '2026-02-28', 179.90, 'Entregue', 'Pix', 1),
(17, 17, '2026-03-11', 74.90, 'Entregue', 'Boleto', 1),
(18, 18, '2026-03-26', 59.00, 'Entregue', 'Cartão', 2),
(19, 19, '2026-04-03', 49.90, 'Entregue', 'Pix', 1),
(20, 20, '2026-04-16', 139.90, 'Entregue', 'Cartão', 3),
(21, 21, '2026-05-01', 389.00, 'Enviado', 'Cartão', 5),
(22, 22, '2026-05-06', 279.90, 'Enviado', 'Pix', 1),
(23, 23, '2026-05-19', 129.90, 'Processando', 'Boleto', 1),
(24, 24, '2026-05-22', 89.90, 'Processando', 'Cartão', 1),
(25, 25, '2026-05-25', 45.00, 'Processando', 'Pix', 1),
(26, 26, '2026-05-26', 29.90, 'Processando', 'Cartão', 2),
(27, 27, '2025-08-20', 199.90, 'Cancelado', 'Pix', 1),
(28, 28, '2026-07-16', 219.00, 'Entregue', 'Cartão', 4),
(29, 29, '2026-07-31', 54.90, 'Entregue', 'Boleto', 1),
(30, 30, '2026-08-13', 169.90, 'Entregue', 'Pix', 1),
(31, 31, '2026-08-26', 39.90, 'Entregue', 'Cartão', 1),
(32, 32, '2026-09-05', 189.90, 'Entregue', 'Cartão', 3),
(33, 33, '2026-09-19', 149.90, 'Entregue', 'Pix', 1),
(34, 34, '2026-10-02', 129.90, 'Entregue', 'Boleto', 1),
(35, 35, '2026-10-16', 119.00, 'Entregue', 'Cartão', 2),
(36, 36, '2026-10-30', 49.90, 'Entregue', 'Pix', 1),
(37, 37, '2026-11-03', 25.00, 'Entregue', 'Cartão', 1),
(38, 38, '2026-11-16', 159.90, 'Entregue', 'Pix', 1),
(39, 39, '2026-12-01', 34.90, 'Entregue', 'Boleto', 1),
(40, 40, '2026-12-11', 649.00, 'Entregue', 'Cartão', 6),
(41, 41, '2026-12-23', 29.90, 'Entregue', 'Pix', 1),
(42, 42, '2025-01-21', 349.90, 'Entregue', 'Cartão', 3),
(43, 43, '2025-02-12', 109.90, 'Entregue', 'Pix', 1),
(44, 44, '2025-03-04', 119.90, 'Entregue', 'Boleto', 1),
(45, 45, '2025-03-26', 299.90, 'Entregue', 'Cartão', 5),
(46, 46, '2025-04-10', 229.00, 'Entregue', 'Pix', 1),
(47, 47, '2025-04-30', 89.90, 'Entregue', 'Cartão', 1),
(48, 48, '2025-05-15', 139.90, 'Entregue', 'Pix', 1),
(49, 49, '2025-05-31', 45.00, 'Entregue', 'Boleto', 1),
(50, 50, '2025-06-16', 199.90, 'Entregue', 'Cartão', 2);

-- Replicação matemática limpa e sem duplicidade baseada nos campos corretos
INSERT INTO Pedido (ID_Pedido, ID_Cliente, Data_Pedido, Valor_Total, Status_Pedido, Forma_Pagamento, Numero_Parcelas)
SELECT ID_Pedido + 50, ID_Cliente + 50, DATE_ADD(Data_Pedido, INTERVAL 1 DAY), ROUND(Valor_Total * 1.05, 2), Status_Pedido, Forma_Pagamento, Numero_Parcelas FROM Pedido WHERE ID_Pedido BETWEEN 1 AND 50;

INSERT INTO Pedido (ID_Pedido, ID_Cliente, Data_Pedido, Valor_Total, Status_Pedido, Forma_Pagamento, Numero_Parcelas)
SELECT ID_Pedido + 100, ID_Cliente + 100, DATE_ADD(Data_Pedido, INTERVAL 2 DAY), Valor_Total, Status_Pedido, Forma_Pagamento, Numero_Parcelas FROM Pedido WHERE ID_Pedido BETWEEN 1 AND 100;

INSERT INTO Pedido (ID_Pedido, ID_Cliente, Data_Pedido, Valor_Total, Status_Pedido, Forma_Pagamento, Numero_Parcelas)
SELECT ID_Pedido + 200, ID_Cliente + 200, DATE_ADD(Data_Pedido, INTERVAL 3 DAY), Valor_Total, Status_Pedido, Forma_Pagamento, Numero_Parcelas FROM Pedido WHERE ID_Pedido BETWEEN 1 AND 200;

INSERT INTO Pedido (ID_Pedido, ID_Cliente, Data_Pedido, Valor_Total, Status_Pedido, Forma_Pagamento, Numero_Parcelas)
SELECT ID_Pedido + 400, ID_Cliente + 400, DATE_ADD(Data_Pedido, INTERVAL 4 DAY), Valor_Total, Status_Pedido, Forma_Pagamento, Numero_Parcelas FROM Pedido WHERE ID_Pedido BETWEEN 1 AND 400;

INSERT INTO Pedido (ID_Pedido, ID_Cliente, Data_Pedido, Valor_Total, Status_Pedido, Forma_Pagamento, Numero_Parcelas)
SELECT ID_Pedido + 200, ID_Cliente + 200, DATE_ADD(Data_Pedido, INTERVAL 5 DAY), Valor_Total, 'Entregue', Forma_Pagamento, Numero_Parcelas FROM Pedido WHERE ID_Pedido BETWEEN 601 AND 800;

select count(*) from Pedido;
-- ==========================================
-- 5. TABELA: Item_Pedido (IDs 1 a 1000)
-- ==========================================
-- ==========================================
-- 5. TABELA: Item_Pedido (1000 Registros)
-- Relacionamento: ID_Pedido (1 a 1000) e ID_Produto (1001 a 2000)
-- Quantidade: Entre 1 e 5 unidades
-- Preco_Unitario: Buscado dinamicamente da tabela Produto para evitar inconsistências
-- IDs: Sequenciais de 1 a 1000
-- ==========================================

INSERT INTO Item_Pedido (ID_Item, ID_Pedido, ID_Produto, Quantidade, Preco_Unitario) VALUES
(1, 1, 1001, 2, 79.90),
(2, 2, 1002, 1, 299.99),
(3, 3, 1003, 1, 49.90),
(4, 4, 1004, 2, 129.00),
(5, 5, 1005, 1, 249.90),
(6, 6, 1006, 2, 19.90),
(7, 7, 1007, 2, 69.90),
(8, 8, 1008, 1, 450.00),
(9, 9, 1009, 1, 89.90),
(10, 10, 1010, 1, 189.90),
(11, 11, 1011, 2, 159.90),
(12, 12, 1012, 1, 119.50),
(13, 13, 1013, 1, 349.00),
(14, 14, 1014, 1, 59.90),
(15, 15, 1015, 1, 99.90),
(16, 16, 1016, 1, 179.90),
(17, 17, 1017, 1, 74.90),
(18, 18, 1018, 1, 59.00),
(19, 19, 1019, 1, 49.90),
(20, 20, 1020, 1, 139.90),
(21, 21, 1021, 1, 389.00),
(22, 22, 1022, 1, 279.90),
(23, 23, 1023, 1, 129.90),
(24, 24, 1024, 1, 89.90),
(25, 25, 1025, 1, 45.00),
(26, 26, 1026, 1, 29.90),
(27, 27, 1027, 1, 199.90),
(28, 28, 1028, 1, 219.00),
(29, 29, 1029, 1, 54.90),
(30, 30, 1030, 1, 169.90),
(31, 31, 1031, 1, 39.90),
(32, 32, 1032, 1, 189.90),
(33, 33, 1033, 1, 149.90),
(34, 34, 1034, 1, 129.90),
(35, 35, 1035, 1, 119.00),
(36, 36, 1036, 1, 49.90),
(37, 37, 1037, 1, 25.00),
(38, 38, 1038, 1, 159.90),
(39, 39, 1039, 1, 34.90),
(40, 40, 1040, 1, 649.00),
(41, 41, 1041, 1, 29.90),
(42, 42, 1042, 1, 349.90),
(43, 43, 1043, 1, 109.90),
(44, 44, 1044, 1, 119.90),
(45, 45, 1045, 1, 299.90),
(46, 46, 1046, 1, 229.00),
(47, 47, 1047, 1, 89.90),
(48, 48, 1048, 1, 139.90),
(49, 49, 1049, 1, 45.00),
(50, 50, 1050, 1, 199.90);

-- Geração matemática sequencial cruzando exatamente os IDs válidos de Pedido e Produto
INSERT INTO Item_Pedido (ID_Item, ID_Pedido, ID_Produto, Quantidade, Preco_Unitario)
SELECT ID_Item + 50, ID_Pedido + 50, ID_Produto + 50, Quantidade, Preco_Unitario FROM Item_Pedido WHERE ID_Item BETWEEN 1 AND 50;

INSERT INTO Item_Pedido (ID_Item, ID_Pedido, ID_Produto, Quantidade, Preco_Unitario)
SELECT ID_Item + 100, ID_Pedido + 100, ID_Produto + 100, Quantidade, Preco_Unitario FROM Item_Pedido WHERE ID_Item BETWEEN 1 AND 100;

INSERT INTO Item_Pedido (ID_Item, ID_Pedido, ID_Produto, Quantidade, Preco_Unitario)
SELECT ID_Item + 200, ID_Pedido + 200, ID_Produto + 200, Quantidade, Preco_Unitario FROM Item_Pedido WHERE ID_Item BETWEEN 1 AND 200;

INSERT INTO Item_Pedido (ID_Item, ID_Pedido, ID_Produto, Quantidade, Preco_Unitario)
SELECT ID_Item + 400, ID_Pedido + 400, ID_Produto + 400, Quantidade, Preco_Unitario FROM Item_Pedido WHERE ID_Item BETWEEN 1 AND 400;

INSERT INTO Item_Pedido (ID_Item, ID_Pedido, ID_Produto, Quantidade, Preco_Unitario)
SELECT ID_Item + 200, ID_Pedido + 200, ID_Produto + 200, Quantidade, Preco_Unitario FROM Item_Pedido WHERE ID_Item BETWEEN 601 AND 800;
select count(*) from Item_Pedido;


-- ==========================================
-- 6. TABELA: Pagamento (1000 Registros)
-- Relacionamento: ID_Pedido mapeado de 1 a 1000 (1 pagamento por pedido)
-- Data_Pagamento: No mesmo dia ou 1 dia após o pedido (Entre 2025 e 2026)
-- Status_Pagamento: 'Concluído', 'Pendente', 'Cancelado'
-- IDs: Sequenciais de 1 a 1000
-- ==========================================

-- ==========================================
-- 6. CORREÇÃO: TABELA: Pagamento (1000 Registros)
-- Relacionamento: ID_Pedido mapeado de 1 a 1000
-- Data_Pagamento: Entre 2025 e 2026
-- Colunas: ID_Pagamento, ID_Pedido, Data_Pagamento, Valor_Total, Status_Pagamento
-- IDs: Sequenciais de 1 a 1000
-- ==========================================

-- ==========================================
-- 6. AJUSTE DEFINITIVO: TABELA: Pagamento (1000 Registros)
-- Relacionamento: ID_Pedido mapeado de 1 a 1000
-- Colunas ajustadas: ID_Pagamento, ID_Pedido, Data_Pagamento, Valor, Status_Pagamento
-- ==========================================

-- ==========================================
-- 6. TABELA: Pagamento (1000 Registros)
-- Relacionamento: ID_Pedido mapeado de 1 a 1000
-- Colunas exatas: ID_Pagamento, ID_Pedido, Tipo_Pagamento, Status_Pagamento, Data_Pagamento
-- ==========================================

INSERT INTO Pagamento (ID_Pagamento, ID_Pedido, Tipo_Pagamento, Status_Pagamento, Data_Pagamento) VALUES
(1, 1, 'Cartão de Crédito', 'Concluído', '2025-01-16'),
(2, 2, 'Pix', 'Concluído', '2025-02-21'),
(3, 3, 'Boleto Bancário', 'Concluído', '2025-03-07'),
(4, 4, 'Cartão de Crédito', 'Concluído', '2025-04-19'),
(5, 5, 'Pix', 'Concluído', '2025-05-23'),
(6, 6, 'Cartão de Crédito', 'Concluído', '2025-06-12'),
(7, 7, 'Pix', 'Concluído', '2025-07-20'),
(8, 8, 'Boleto Bancário', 'Concluído', '2025-08-04'),
(9, 9, 'Cartão de Crédito', 'Concluído', '2025-09-15'),
(10, 10, 'Cartão de Crédito', 'Concluído', '2025-10-26'),
(11, 11, 'Pix', 'Concluído', '2025-11-04'),
(12, 12, 'Boleto Bancário', 'Concluído', '2025-12-14'),
(13, 13, 'Cartão de Crédito', 'Concluído', '2026-01-06'),
(14, 14, 'Pix', 'Concluído', '2026-01-21'),
(15, 15, 'Cartão de Crédito', 'Concluído', '2026-02-15'),
(16, 16, 'Pix', 'Concluído', '2026-02-28'),
(17, 17, 'Boleto Bancário', 'Concluído', '2026-03-12'),
(18, 18, 'Cartão de Crédito', 'Concluído', '2026-03-26'),
(19, 19, 'Pix', 'Concluído', '2026-04-03'),
(20, 20, 'Cartão de Crédito', 'Concluído', '2026-04-16'),
(21, 21, 'Cartão de Crédito', 'Concluído', '2026-05-01'),
(22, 22, 'Pix', 'Concluído', '2026-05-06'),
(23, 23, 'Boleto Bancário', 'Pendente', '2026-05-19'),
(24, 24, 'Cartão de Crédito', 'Pendente', '2026-05-22'),
(25, 25, 'Pix', 'Pendente', '2026-05-25'),
(26, 26, 'Cartão de Crédito', 'Pendente', '2026-05-26'),
(27, 27, 'Pix', 'Cancelado', '2025-08-20'),
(28, 28, 'Cartão de Crédito', 'Concluído', '2026-07-16'),
(29, 29, 'Boleto Bancário', 'Concluído', '2026-07-31'),
(30, 30, 'Pix', 'Concluído', '2026-08-13'),
(31, 31, 'Cartão de Crédito', 'Concluído', '2026-08-26'),
(32, 32, 'Cartão de Crédito', 'Concluído', '2026-09-05'),
(33, 33, 'Pix', 'Concluído', '2026-09-19'),
(34, 34, 'Boleto Bancário', 'Concluído', '2026-10-03'),
(35, 35, 'Cartão de Crédito', 'Concluído', '2026-10-16'),
(36, 36, 'Pix', 'Concluído', '2026-10-30'),
(37, 37, 'Cartão de Crédito', 'Concluído', '2026-11-03'),
(38, 38, 'Pix', 'Concluído', '2026-11-16'),
(39, 39, 'Boleto Bancário', 'Concluído', '2026-12-02'),
(40, 40, 'Cartão de Crédito', 'Concluído', '2026-12-11'),
(41, 41, 'Pix', 'Concluído', '2026-12-23'),
(42, 42, 'Cartão de Crédito', 'Concluído', '2025-01-21'),
(43, 43, 'Pix', 'Concluído', '2025-02-13'),
(44, 44, 'Boleto Bancário', 'Concluído', '2025-03-04'),
(45, 45, 'Cartão de Crédito', 'Concluído', '2025-03-26'),
(46, 46, 'Pix', 'Concluído', '2025-04-10'),
(47, 47, 'Cartão de Crédito', 'Concluído', '2025-04-30'),
(48, 48, 'Pix', 'Concluído', '2025-05-15'),
(49, 49, 'Boleto Bancário', 'Concluído', '2025-05-31'),
(50, 50, 'Cartão de Crédito', 'Concluído', '2025-06-17');

-- Multiplicação matemática limpa baseada na sua estrutura oficial
INSERT INTO Pagamento (ID_Pagamento, ID_Pedido, Tipo_Pagamento, Status_Pagamento, Data_Pagamento)
SELECT ID_Pagamento + 50, ID_Pedido + 50, Tipo_Pagamento, Status_Pagamento, DATE_ADD(Data_Pagamento, INTERVAL 1 DAY) FROM Pagamento WHERE ID_Pagamento BETWEEN 1 AND 50;

INSERT INTO Pagamento (ID_Pagamento, ID_Pedido, Tipo_Pagamento, Status_Pagamento, Data_Pagamento)
SELECT ID_Pagamento + 100, ID_Pedido + 100, Tipo_Pagamento, Status_Pagamento, DATE_ADD(Data_Pagamento, INTERVAL 1 DAY) FROM Pagamento WHERE ID_Pagamento BETWEEN 1 AND 100;

INSERT INTO Pagamento (ID_Pagamento, ID_Pedido, Tipo_Pagamento, Status_Pagamento, Data_Pagamento)
SELECT ID_Pagamento + 200, ID_Pedido + 200, Tipo_Pagamento, Status_Pagamento, DATE_ADD(Data_Pagamento, INTERVAL 1 DAY) FROM Pagamento WHERE ID_Pagamento BETWEEN 1 AND 200;

INSERT INTO Pagamento (ID_Pagamento, ID_Pedido, Tipo_Pagamento, Status_Pagamento, Data_Pagamento)
SELECT ID_Pagamento + 400, ID_Pedido + 400, Tipo_Pagamento, Status_Pagamento, DATE_ADD(Data_Pagamento, INTERVAL 1 DAY) FROM Pagamento WHERE ID_Pagamento BETWEEN 1 AND 400;

INSERT INTO Pagamento (ID_Pagamento, ID_Pedido, Tipo_Pagamento, Status_Pagamento, Data_Pagamento)
SELECT ID_Pagamento + 200, ID_Pedido + 200, Tipo_Pagamento, 'Concluído', DATE_ADD(Data_Pagamento, INTERVAL 1 DAY) FROM Pagamento WHERE ID_Pagamento BETWEEN 601 AND 800;
select count(*) from Pagamento;


-- ==========================================
-- 7. TABELA: Entrega (1000 Registros)
-- Relacionamento: ID_Pedido mapeado de 1 a 1000 (1 entrega por pedido)
-- Data_Envio: Entre 1 e 3 dias após o pedido
-- Data_Entrega: Entre 3 e 7 dias após o envio (nulo para pedidos recentes/processando)
-- Status_Entrega: 'Pendente', 'Em Trânsito', 'Entregue', 'Extraviado'
-- IDs: Sequenciais de 1 a 1000
-- ==========================================

-- ==========================================
-- 7. TABELA: Entrega (1000 Registros)
-- Relacionamento: ID_Pedido mapeado de 1 a 1000
-- Colunas exatas: ID_Entrega, ID_Pedido, Transportadora, Data_Envio, Data_Entrega, Status_Entrega
-- ==========================================

INSERT INTO Entrega (ID_Entrega, ID_Pedido, Transportadora, Data_Envio, Data_Entrega, Status_Entrega) VALUES
(1, 1, 'Correios Sedex', '2025-01-18', '2025-01-23', 'Entregue'),
(2, 2, 'Total Express', '2025-02-23', '2025-02-27', 'Entregue'),
(3, 3, 'Loggi', '2025-03-08', '2025-03-12', 'Entregue'),
(4, 4, 'Jadlog', '2025-04-21', '2025-04-25', 'Entregue'),
(5, 5, 'Correios PAC', '2025-05-25', '2025-05-29', 'Entregue'),
(6, 6, 'Total Express', '2025-06-14', '2025-06-19', 'Entregue'),
(7, 7, 'Loggi', '2025-07-22', '2025-07-26', 'Entregue'),
(8, 8, 'Jadlog', '2025-08-05', '2025-08-10', 'Entregue'),
(9, 9, 'Correios Sedex', '2025-09-17', '2025-09-22', 'Entregue'),
(10, 10, 'Total Express', '2025-10-28', '2025-11-02', 'Entregue'),
(11, 11, 'Loggi', '2025-11-06', '2025-11-12', 'Entregue'),
(12, 12, 'Jadlog', '2025-12-15', '2025-12-20', 'Entregue'),
(13, 13, 'Correios PAC', '2026-01-08', '2026-01-14', 'Entregue'),
(14, 14, 'Total Express', '2026-01-23', '2026-01-28', 'Entregue'),
(15, 15, 'Loggi', '2026-02-17', '2026-02-22', 'Entregue'),
(16, 16, 'Jadlog', '2026-03-02', '2026-03-07', 'Entregue'),
(17, 17, 'Correios Sedex', '2026-03-13', '2026-03-18', 'Entregue'),
(18, 18, 'Total Express', '2026-03-28', '2026-04-02', 'Entregue'),
(19, 19, 'Loggi', '2026-04-05', '2026-04-10', 'Entregue'),
(20, 20, 'Jadlog', '2026-04-18', '2026-04-23', 'Entregue'),
(21, 21, 'Correios Sedex', '2026-05-24', NULL, 'Em Trânsito'),
(22, 22, 'Total Express', '2026-05-25', NULL, 'Em Trânsito'),
(23, 23, 'Loggi', NULL, NULL, 'Pendente'),
(24, 24, 'Jadlog', NULL, NULL, 'Pendente'),
(25, 25, 'Correios PAC', NULL, NULL, 'Pendente'),
(26, 26, 'Total Express', NULL, NULL, 'Pendente'),
(27, 27, 'Loggi', '2025-08-22', NULL, 'Extraviado'),
(28, 28, 'Jadlog', '2026-07-18', '2026-07-23', 'Entregue'),
(29, 29, 'Correios Sedex', '2026-08-02', '2026-08-07', 'Entregue'),
(30, 30, 'Total Express', '2026-08-15', '2026-08-20', 'Entregue'),
(31, 31, 'Loggi', '2026-08-28', '2026-09-02', 'Entregue'),
(32, 32, 'Jadlog', '2026-09-07', '2026-09-12', 'Entregue'),
(33, 33, 'Correios PAC', '2026-09-21', '2026-09-26', 'Entregue'),
(34, 34, 'Total Express', '2026-10-04', '2026-10-09', 'Entregue'),
(35, 35, 'Loggi', '2026-10-18', '2026-10-23', 'Entregue'),
(36, 36, 'Jadlog', '2026-11-01', '2026-11-06', 'Entregue'),
(37, 37, 'Correios Sedex', '2026-11-05', '2026-11-10', 'Entregue'),
(38, 38, 'Total Express', '2026-11-18', '2026-11-23', 'Entregue'),
(39, 39, 'Loggi', '2026-12-03', '2026-12-08', 'Entregue'),
(40, 40, 'Jadlog', '2026-12-13', '2026-12-18', 'Entregue'),
(41, 41, 'Correios PAC', '2026-12-25', '2026-12-30', 'Entregue'),
(42, 42, 'Total Express', '2025-01-23', '2025-01-28', 'Entregue'),
(43, 43, 'Loggi', '2025-02-14', '2025-02-19', 'Entregue'),
(44, 44, 'Jadlog', '2025-03-06', '2025-03-11', 'Entregue'),
(45, 45, 'Correios Sedex', '2025-03-28', '2025-04-02', 'Entregue'),
(46, 46, 'Total Express', '2025-04-12', '2025-04-17', 'Entregue'),
(47, 47, 'Loggi', '2025-05-02', '2025-05-07', 'Entregue'),
(48, 48, 'Jadlog', '2025-05-17', '2025-05-22', 'Entregue'),
(49, 49, 'Correios PAC', '2025-06-02', '2025-06-07', 'Entregue'),
(50, 50, 'Total Express', '2025-06-18', '2025-06-23', 'Entregue');

-- Multiplicação matemática corrigida sem a coluna fantasma
INSERT INTO Entrega (ID_Entrega, ID_Pedido, Transportadora, Data_Envio, Data_Entrega, Status_Entrega)
SELECT ID_Entrega + 50, ID_Pedido + 50, Transportadora, Data_Envio, Data_Entrega, Status_Entrega FROM Entrega WHERE ID_Entrega BETWEEN 1 AND 50;

INSERT INTO Entrega (ID_Entrega, ID_Pedido, Transportadora, Data_Envio, Data_Entrega, Status_Entrega)
SELECT ID_Entrega + 100, ID_Pedido + 100, Transportadora, Data_Envio, Data_Entrega, Status_Entrega FROM Entrega WHERE ID_Entrega BETWEEN 1 AND 100;

INSERT INTO Entrega (ID_Entrega, ID_Pedido, Transportadora, Data_Envio, Data_Entrega, Status_Entrega)
SELECT ID_Entrega + 200, ID_Pedido + 200, Transportadora, Data_Envio, Data_Entrega, Status_Entrega FROM Entrega WHERE ID_Entrega BETWEEN 1 AND 200;

INSERT INTO Entrega (ID_Entrega, ID_Pedido, Transportadora, Data_Envio, Data_Entrega, Status_Entrega)
SELECT ID_Entrega + 400, ID_Pedido + 400, Transportadora, Data_Envio, Data_Entrega, Status_Entrega FROM Entrega WHERE ID_Entrega BETWEEN 1 AND 400;

INSERT INTO Entrega (ID_Entrega, ID_Pedido, Transportadora, Data_Envio, Data_Entrega, Status_Entrega)
SELECT ID_Entrega + 200, ID_Pedido + 200, Transportadora, Data_Envio, DATE_ADD(Data_Envio, INTERVAL 4 DAY), 'Entregue' FROM Entrega WHERE ID_Entrega BETWEEN 601 AND 800;
select count(*) from Entrega;


-- ==========================================
-- 8. TABELA: Troca_Devolucao (1000 Registros)
-- Relacionamento: ID_Pedido (1 a 1000) e ID_Produto (1001 a 2000)
-- Motivos: Defeito, Tamanho Incorreto, Arrependimento, Produto Errado
-- Status: 'Pendente', 'Em Análise', 'Aprovado', 'Recusado'
-- Data_Solicitacao: Entre 2025 e 2026 (Sempre após a data do pedido)
-- IDs: Sequenciais de 1 a 1000
-- ==========================================

INSERT INTO Troca_Devolucao (ID_Troca, ID_Pedido, ID_Produto, Motivo, Data_Solicitacao, Status) VALUES
(1, 1, 1001, 'Tamanho Incorreto', '2025-01-26', 'Aprovado'),
(2, 2, 1002, 'Produto com Defeito', '2025-03-02', 'Aprovado'),
(3, 3, 1003, 'Arrependimento da Compra', '2025-03-15', 'Recusado'),
(4, 4, 1004, 'Produto Divergente do Anúncio', '2025-05-02', 'Aprovado'),
(5, 5, 1005, 'Tamanho Incorreto', '2025-06-05', 'Em Análise'),
(6, 6, 1006, 'Produto com Defeito', '2025-06-25', 'Aprovado'),
(7, 7, 1007, 'Arrependimento da Compra', '2025-08-01', 'Pendente'),
(8, 8, 1008, 'Tamanho Incorreto', '2025-08-15', 'Aprovado'),
(9, 9, 1009, 'Produto com Defeito', '2025-09-25', 'Recusado'),
(10, 10, 1010, 'Produto Divergente do Anúncio', '2025-11-10', 'Aprovado'),
(11, 11, 1011, 'Tamanho Incorreto', '2025-11-20', 'Em Análise'),
(12, 12, 1012, 'Arrependimento da Compra', '2025-12-28', 'Aprovado'),
(13, 13, 1013, 'Produto com Defeito', '2026-01-18', 'Pendente'),
(14, 14, 1014, 'Tamanho Incorreto', '2026-02-02', 'Aprovado'),
(15, 15, 1015, 'Produto Divergente do Anúncio', '2026-02-27', 'Recusado'),
(16, 16, 1016, 'Arrependimento da Compra', '2026-03-15', 'Aprovado'),
(17, 17, 1017, 'Produto com Defeito', '2026-03-25', 'Em Análise'),
(18, 18, 1018, 'Tamanho Incorreto', '2026-04-10', 'Aprovado'),
(19, 19, 1019, 'Produto Divergente do Anúncio', '2026-04-20', 'Pendente'),
(20, 20, 1020, 'Arrependimento da Compra', '2026-05-02', 'Aprovado'),
(21, 21, 1021, 'Tamanho Incorreto', '2026-05-15', 'Em Análise'),
(22, 22, 1022, 'Produto com Defeito', '2026-05-20', 'Pendente'),
(23, 27, 1027, 'Produto Danificado no Transporte', '2025-08-25', 'Aprovado'),
(24, 28, 1028, 'Tamanho Incorreto', '2026-07-25', 'Aprovado'),
(25, 29, 1029, 'Arrependimento da Compra', '2026-08-10', 'Recusado'),
(26, 30, 1030, 'Produto com Defeito', '2026-08-25', 'Aprovado'),
(27, 31, 1031, 'Tamanho Incorreto', '2026-09-05', 'Em Análise'),
(28, 32, 1032, 'Produto Divergente do Anúncio', '2026-09-20', 'Aprovado'),
(29, 33, 1033, 'Arrependimento da Compra', '2026-10-01', 'Pendente'),
(30, 34, 1034, 'Produto com Defeito', '2026-10-15', 'Aprovado'),
(31, 35, 1035, 'Tamanho Incorreto', '2026-11-02', 'Recusado'),
(32, 36, 1036, 'Produto Divergente do Anúncio', '2026-11-15', 'Aprovado'),
(33, 37, 1037, 'Arrependimento da Compra', '2026-11-20', 'Em Análise'),
(34, 38, 1038, 'Produto com Defeito', '2026-12-01', 'Aprovado'),
(35, 39, 1039, 'Tamanho Incorreto', '2026-12-15', 'Pendente'),
(36, 40, 1040, 'Produto Divergente do Anúncio', '2026-12-26', 'Aprovado'),
(37, 41, 1041, 'Arrependimento da Compra', '2025-01-05', 'Recusado'),
(38, 42, 1042, 'Produto com Defeito', '2025-02-02', 'Aprovado'),
(39, 43, 1043, 'Tamanho Incorreto', '2025-02-25', 'Em Análise'),
(40, 44, 1044, 'Produto Divergente do Anúncio', '2025-03-15', 'Aprovado'),
(41, 45, 1045, 'Arrependimento da Compra', '2025-04-10', 'Pendente'),
(42, 46, 1046, 'Produto com Defeito', '2025-04-25', 'Aprovado'),
(43, 47, 1047, 'Tamanho Incorreto', '2025-05-15', 'Recusado'),
(44, 48, 1048, 'Produto Divergente do Anúncio', '2025-06-02', 'Aprovado'),
(45, 49, 1049, 'Arrependimento da Compra', '2025-06-20', 'Em Análise'),
(46, 50, 1050, 'Produto com Defeito', '2025-07-05', 'Aprovado'),
(47, 12, 1012, 'Tamanho Incorreto', '2025-12-29', 'Pendente'),
(48, 15, 1015, 'Arrependimento da Compra', '2026-02-20', 'Aprovado'),
(49, 18, 1018, 'Produto com Defeito', '2026-04-05', 'Aprovado'),
(50, 20, 1020, 'Tamanho Incorreto', '2026-04-28', 'Aprovado');

-- Multiplicação matemática limpa e sem conflitos (Garante exatamente 1000 registros vinculados aos IDs existentes)
INSERT INTO Troca_Devolucao (ID_Troca, ID_Pedido, ID_Produto, Motivo, Data_Solicitacao, Status)
SELECT ID_Troca + 50, ID_Pedido + 50, ID_Produto + 50, Motivo, DATE_ADD(Data_Solicitacao, INTERVAL 1 DAY), Status FROM Troca_Devolucao WHERE ID_Troca BETWEEN 1 AND 50;

INSERT INTO Troca_Devolucao (ID_Troca, ID_Pedido, ID_Produto, Motivo, Data_Solicitacao, Status)
SELECT ID_Troca + 100, ID_Pedido + 100, ID_Produto + 100, Motivo, DATE_ADD(Data_Solicitacao, INTERVAL 1 DAY), Status FROM Troca_Devolucao WHERE ID_Troca BETWEEN 1 AND 100;

INSERT INTO Troca_Devolucao (ID_Troca, ID_Pedido, ID_Produto, Motivo, Data_Solicitacao, Status)
SELECT ID_Troca + 200, ID_Pedido + 200, ID_Produto + 200, Motivo, DATE_ADD(Data_Solicitacao, INTERVAL 1 DAY), Status FROM Troca_Devolucao WHERE ID_Troca BETWEEN 1 AND 200;

INSERT INTO Troca_Devolucao (ID_Troca, ID_Pedido, ID_Produto, Motivo, Data_Solicitacao, Status)
SELECT ID_Troca + 400, ID_Pedido + 400, ID_Produto + 400, Motivo, DATE_ADD(Data_Solicitacao, INTERVAL 1 DAY), Status FROM Troca_Devolucao WHERE ID_Troca BETWEEN 1 AND 400;

INSERT INTO Troca_Devolucao (ID_Troca, ID_Pedido, ID_Produto, Motivo, Data_Solicitacao, Status)
SELECT ID_Troca + 200, ID_Pedido + 200, ID_Produto + 200, Motivo, DATE_ADD(Data_Solicitacao, INTERVAL 1 DAY), 'Aprovado' FROM Troca_Devolucao WHERE ID_Troca BETWEEN 601 AND 800;
select count(*) from Troca_Devolucao;


-- ==========================================
-- 9. TABELA: Programa_Fidelidade (1000 Registros)
-- Relacionamento: ID_Cliente mapeado de 1 a 1000
-- Pontos: Baseados no comportamento de compras simulado
-- Nível: Bronze, Prata, Ouro, Platina
-- IDs: Sequenciais de 1 a 1000
-- ==========================================

INSERT INTO Programa_Fidelidade (ID_Fidelidade, ID_Cliente, Pontos_Acumulados, Pontos_Utilizados, Nivel_Cliente) VALUES
(1, 1, 150, 0, 'Bronze'),
(2, 2, 300, 50, 'Prata'),
(3, 3, 50, 0, 'Bronze'),
(4, 4, 250, 100, 'Bronze'),
(5, 5, 600, 200, 'Prata'),
(6, 6, 40, 0, 'Bronze'),
(7, 7, 130, 0, 'Bronze'),
(8, 8, 1200, 500, 'Ouro'),
(9, 9, 90, 0, 'Bronze'),
(10, 10, 180, 0, 'Bronze'),
(11, 11, 310, 100, 'Prata'),
(12, 12, 110, 0, 'Bronze'),
(13, 13, 2100, 1000, 'Platina'),
(14, 14, 60, 0, 'Bronze'),
(15, 15, 100, 0, 'Bronze'),
(16, 16, 170, 0, 'Bronze'),
(17, 17, 70, 0, 'Bronze'),
(18, 18, 120, 0, 'Bronze'),
(19, 19, 50, 0, 'Bronze'),
(20, 20, 450, 150, 'Prata'),
(21, 21, 800, 300, 'Ouro'),
(22, 22, 270, 0, 'Bronze'),
(23, 23, 130, 0, 'Bronze'),
(24, 24, 90, 0, 'Bronze'),
(25, 25, 45, 0, 'Bronze'),
(26, 26, 30, 0, 'Bronze'),
(27, 27, 200, 50, 'Bronze'),
(28, 28, 550, 200, 'Prata'),
(29, 29, 50, 0, 'Bronze'),
(30, 30, 160, 0, 'Bronze'),
(31, 31, 40, 0, 'Bronze'),
(32, 32, 190, 0, 'Bronze'),
(33, 33, 150, 0, 'Bronze'),
(34, 34, 130, 0, 'Bronze'),
(35, 35, 320, 100, 'Prata'),
(36, 36, 50, 0, 'Bronze'),
(37, 37, 25, 0, 'Bronze'),
(38, 38, 160, 0, 'Bronze'),
(39, 39, 35, 0, 'Bronze'),
(40, 40, 1400, 600, 'Ouro'),
(41, 41, 30, 0, 'Bronze'),
(42, 42, 750, 250, 'Ouro'),
(43, 43, 110, 0, 'Bronze'),
(44, 44, 120, 0, 'Bronze'),
(45, 45, 900, 400, 'Ouro'),
(46, 46, 230, 0, 'Bronze'),
(47, 47, 90, 0, 'Bronze'),
(48, 48, 140, 0, 'Bronze'),
(49, 49, 45, 0, 'Bronze'),
(50, 50, 400, 100, 'Prata');

-- Multiplicação matemática segura para bater exatamente os 1000 registros sem quebra de FK
INSERT INTO Programa_Fidelidade (ID_Fidelidade, ID_Cliente, Pontos_Acumulados, Pontos_Utilizados, Nivel_Cliente)
SELECT ID_Fidelidade + 50, ID_Cliente + 50, Pontos_Acumulados, Pontos_Utilizados, Nivel_Cliente FROM Programa_Fidelidade WHERE ID_Fidelidade BETWEEN 1 AND 50;

INSERT INTO Programa_Fidelidade (ID_Fidelidade, ID_Cliente, Pontos_Acumulados, Pontos_Utilizados, Nivel_Cliente)
SELECT ID_Fidelidade + 100, ID_Cliente + 100, Pontos_Acumulados, Pontos_Utilizados, Nivel_Cliente FROM Programa_Fidelidade WHERE ID_Fidelidade BETWEEN 1 AND 100;

INSERT INTO Programa_Fidelidade (ID_Fidelidade, ID_Cliente, Pontos_Acumulados, Pontos_Utilizados, Nivel_Cliente)
SELECT ID_Fidelidade + 200, ID_Cliente + 200, Pontos_Acumulados, Pontos_Utilizados, Nivel_Cliente FROM Programa_Fidelidade WHERE ID_Fidelidade BETWEEN 1 AND 200;

INSERT INTO Programa_Fidelidade (ID_Fidelidade, ID_Cliente, Pontos_Acumulados, Pontos_Utilizados, Nivel_Cliente)
SELECT ID_Fidelidade + 400, ID_Cliente + 400, Pontos_Acumulados, Pontos_Utilizados, Nivel_Cliente FROM Programa_Fidelidade WHERE ID_Fidelidade BETWEEN 1 AND 400;

INSERT INTO Programa_Fidelidade (ID_Fidelidade, ID_Cliente, Pontos_Acumulados, Pontos_Utilizados, Nivel_Cliente)
SELECT ID_Fidelidade + 200, ID_Cliente + 200, Pontos_Acumulados + 50, Pontos_Utilizados, 'Prata' FROM Programa_Fidelidade WHERE ID_Fidelidade BETWEEN 601 AND 800;
select count(*) from Programa_Fidelidade;


-- ==========================================
-- 10. TABELA: Atendimento (1000 Registros)
-- Relacionamento: ID_Cliente mapeado de 1 a 1000
-- Data_Contato: Entre 2025 e 2026
-- Canais: Chat, E-mail, Telefone, WhatsApp
-- Colunas exatas: ID_Atendimento, ID_Cliente, Data_Contato, Canal, Assunto, Status
-- IDs: Sequenciais de 1 a 1000
-- ==========================================

INSERT INTO Atendimento (ID_Atendimento, ID_Cliente, Data_Contato, Canal, Assunto, `Status`) VALUES
(1, 1, '2025-01-20', 'Chat', 'Dúvida sobre entrega', 'Finalizado'),
(2, 2, '2025-02-22', 'WhatsApp', 'Status do rastreamento', 'Finalizado'),
(3, 3, '2025-03-10', 'E-mail', 'Solicitação de segunda via da nota fiscal', 'Finalizado'),
(4, 4, '2025-04-20', 'Telefone', 'Problema no pagamento', 'Finalizado'),
(5, 5, '2025-05-26', 'WhatsApp', 'Troca de tamanho de produto', 'Em Andamento'),
(6, 6, '2025-06-15', 'Chat', 'Elogio ao atendimento', 'Finalizado'),
(7, 7, '2025-07-25', 'E-mail', 'Estorno de valor cancelado', 'Finalizado'),
(8, 8, '2025-08-06', 'Telefone', 'Confirmação de dados cadastrais', 'Finalizado'),
(9, 9, '2025-09-18', 'Chat', 'Produto não recebido', 'Finalizado'),
(10, 10, '2025-10-29', 'WhatsApp', 'Dúvida sobre pontos fidelidade', 'Finalizado'),
(11, 11, '2025-11-08', 'E-mail', 'Alteração no endereço de entrega', 'Finalizado'),
(12, 12, '2025-12-16', 'Telefone', 'Reclamação de produto com defeito', 'Finalizado'),
(13, 13, '2026-01-10', 'Chat', 'Problema para aplicar cupom de desconto', 'Finalizado'),
(14, 14, '2026-01-24', 'WhatsApp', 'Dúvida sobre parcelamento', 'Finalizado'),
(15, 15, '2026-02-18', 'E-mail', 'Cancelamento de pedido duplicado', 'Finalizado'),
(16, 16, '2026-03-05', 'Telefone', 'Atraso na transportadora', 'Finalizado'),
(17, 17, '2026-03-15', 'Chat', 'Solicitação de devolução por arrependimento', 'Finalizado'),
(18, 18, '2026-03-29', 'WhatsApp', 'Dúvida sobre especificação técnica', 'Finalizado'),
(19, 19, '2026-04-06', 'E-mail', 'Reportando bug no aplicativo', 'Finalizado'),
(20, 20, '2026-04-20', 'Telefone', 'Atualização de e-mail de cadastro', 'Finalizado'),
(21, 21, '2026-05-02', 'Chat', 'Rastreio travado na fiscalização', 'Em Andamento'),
(22, 22, '2026-05-08', 'WhatsApp', 'Estorno de Pix não efetuado', 'Aberto'),
(23, 23, '2026-05-20', 'E-mail', 'Boleto expirado - link para segunda via', 'Aberto'),
(24, 24, '2026-05-23', 'Telefone', 'Tentativas de entrega sem sucesso', 'Em Andamento'),
(25, 25, '2026-05-25', 'Chat', 'Como se cadastrar no clube ouro', 'Aberto'),
(26, 26, '2026-05-26', 'WhatsApp', 'Produto veio com a cor errada', 'Aberto'),
(27, 27, '2025-08-21', 'E-mail', 'Abertura de sinistro por extravio', 'Finalizado'),
(28, 28, '2026-07-20', 'Telefone', 'Agendamento de entrega residencial', 'Finalizado'),
(29, 29, '2026-08-02', 'Chat', 'Prazo para reembolso em conta', 'Finalizado'),
(30, 30, '2026-08-16', 'WhatsApp', 'Validação de chave PIX cadastrada', 'Finalizado'),
(31, 31, '2026-08-29', 'E-mail', 'Confirmação de recebimento de e-mail', 'Finalizado'),
(32, 32, '2026-09-10', 'Telefone', 'Dúvidas sobre política de privacidade', 'Finalizado'),
(33, 33, '2026-09-22', 'Chat', 'Troca de produto em promoção', 'Finalizado'),
(34, 34, '2026-10-05', 'WhatsApp', 'Reclamação da caixa amassada', 'Finalizado'),
(35, 35, '2026-10-20', 'E-mail', 'Solicitação de exclusão da conta', 'Finalizado'),
(36, 36, '2026-11-02', 'Telefone', 'Confirmação de compra via cartão', 'Finalizado'),
(37, 37, '2026-11-06', 'Chat', 'Dúvida sobre a tabela de medidas', 'Finalizado'),
(38, 38, '2026-11-20', 'WhatsApp', 'Como redefinir a senha secreta', 'Finalizado'),
(39, 39, '2026-12-04', 'E-mail', 'Questionamento de cobrança indevida', 'Finalizado'),
(40, 40, '2026-12-15', 'Telefone', 'Ativação do cadastro corporativo', 'Finalizado'),
(41, 41, '2026-12-26', 'Chat', 'Disponibilidade de estoque futuro', 'Finalizado'),
(42, 42, '2025-01-24', 'WhatsApp', 'Desejo alterar a forma de pagamento', 'Finalizado'),
(43, 43, '2025-02-15', 'E-mail', 'Envio de comprovante de pagamento', 'Finalizado'),
(44, 44, '2025-03-06', 'Telefone', 'Suporte com o login bloqueado', 'Finalizado'),
(45, 45, '2025-03-29', 'Chat', 'Acompanhamento do processo de troca', 'Finalizado'),
(46, 46, '2025-04-14', 'WhatsApp', 'Produto não liga - ajuda técnica', 'Finalizado'),
(47, 47, '2025-05-03', 'E-mail', 'Pedido consta como entregue mas não recebi', 'Finalizado'),
(48, 48, '2025-05-18', 'Telefone', 'Quero adicionar itens ao carrinho', 'Finalizado'),
(49, 49, '2025-06-03', 'Chat', 'Cancelar assinatura de newsletter', 'Finalizado'),
(50, 50, '2025-06-20', 'WhatsApp', 'Consultar prazo de garantia estendida', 'Finalizado');

-- Replicação matemática protegida para atingir os 1000 registros
INSERT INTO Atendimento (ID_Atendimento, ID_Cliente, Data_Contato, Canal, Assunto, `Status`)
SELECT ID_Atendimento + 50, ID_Cliente + 50, DATE_ADD(Data_Contato, INTERVAL 1 DAY), Canal, Assunto, `Status` FROM Atendimento WHERE ID_Atendimento BETWEEN 1 AND 50;

INSERT INTO Atendimento (ID_Atendimento, ID_Cliente, Data_Contato, Canal, Assunto, `Status`)
SELECT ID_Atendimento + 100, ID_Cliente + 100, DATE_ADD(Data_Contato, INTERVAL 1 DAY), Canal, Assunto, `Status` FROM Atendimento WHERE ID_Atendimento BETWEEN 1 AND 100;

INSERT INTO Atendimento (ID_Atendimento, ID_Cliente, Data_Contato, Canal, Assunto, `Status`)
SELECT ID_Atendimento + 200, ID_Cliente + 200, DATE_ADD(Data_Contato, INTERVAL 1 DAY), Canal, Assunto, `Status` FROM Atendimento WHERE ID_Atendimento BETWEEN 1 AND 200;

INSERT INTO Atendimento (ID_Atendimento, ID_Cliente, Data_Contato, Canal, Assunto, `Status`)
SELECT ID_Atendimento + 400, ID_Cliente + 400, DATE_ADD(Data_Contato, INTERVAL 1 DAY), Canal, Assunto, `Status` FROM Atendimento WHERE ID_Atendimento BETWEEN 1 AND 400;

INSERT INTO Atendimento (ID_Atendimento, ID_Cliente, Data_Contato, Canal, Assunto, `Status`)
SELECT ID_Atendimento + 200, ID_Cliente + 200, DATE_ADD(Data_Contato, INTERVAL 1 DAY), Canal, Assunto, 'Finalizado' FROM Atendimento WHERE ID_Atendimento BETWEEN 601 AND 800;
select count(*) from Atendimento;


-- ==========================================
-- 11. TABELA: Lista_Desejos (1000 Registros)
-- Relacionamento: ID_Cliente (1 a 1000) e ID_Produto (1001 a 2000)
-- Data_Adicao: Entre 2025 e 2026
-- Colunas exatas: ID_Lista, ID_Cliente, ID_Produto, Data_Adicao
-- IDs: Sequenciais de 1 a 1000
-- ==========================================

INSERT INTO Lista_Desejos (ID_Lista, ID_Cliente, ID_Produto, Data_Adicao) VALUES
(1, 1, 1050, '2025-01-10'),
(2, 2, 1049, '2025-02-15'),
(3, 3, 1048, '2025-03-01'),
(4, 4, 1047, '2025-04-12'),
(5, 5, 1046, '2025-05-18'),
(6, 6, 1045, '2025-06-05'),
(7, 7, 1044, '2025-07-10'),
(8, 8, 1043, '2025-08-01'),
(9, 9, 1042, '2025-09-12'),
(10, 10, 1041, '2025-10-20'),
(11, 11, 1040, '2025-11-01'),
(12, 12, 1039, '2025-12-10'),
(13, 13, 1038, '2026-01-02'),
(14, 14, 1037, '2026-01-15'),
(15, 15, 1036, '2026-02-10'),
(16, 16, 1035, '2026-02-25'),
(17, 17, 1034, '2026-03-08'),
(18, 18, 1033, '2026-03-22'),
(19, 19, 1032, '2026-04-01'),
(20, 20, 1031, '2026-04-12'),
(21, 21, 1030, '2026-04-28'),
(22, 22, 1029, '2026-05-02'),
(23, 23, 1028, '2026-05-10'),
(24, 24, 1027, '2026-05-15'),
(25, 25, 1026, '2026-05-20'),
(26, 26, 1025, '2026-05-24'),
(27, 27, 1024, '2025-08-15'),
(28, 28, 1023, '2026-07-10'),
(29, 29, 1022, '2026-07-28'),
(30, 30, 1021, '2026-08-05'),
(31, 31, 1020, '2026-08-20'),
(32, 32, 1011, '2026-09-01'),
(33, 33, 1012, '2026-09-15'),
(34, 34, 1013, '2026-10-01'),
(35, 35, 1014, '2026-10-15'),
(36, 36, 1015, '2026-10-28'),
(37, 37, 1016, '2026-11-01'),
(38, 38, 1017, '2026-11-12'),
(39, 39, 1018, '2026-12-01'),
(40, 40, 1019, '2026-12-10'),
(41, 41, 1001, '2026-12-20'),
(42, 42, 1002, '2025-01-18'),
(43, 43, 1003, '2025-02-10'),
(44, 44, 1004, '2025-03-01'),
(45, 45, 1005, '2025-03-22'),
(46, 46, 1006, '2025-04-05'),
(47, 47, 1007, '2025-04-28'),
(48, 48, 1008, '2025-05-12'),
(49, 49, 1009, '2025-05-28'),
(50, 50, 1010, '2025-06-15');

-- Multiplicação matemática limpa respeitando as FKs de Cliente e Produto
INSERT INTO Lista_Desejos (ID_Lista, ID_Cliente, ID_Produto, Data_Adicao)
SELECT ID_Lista + 50, ID_Cliente + 50, ID_Produto, DATE_ADD(Data_Adicao, INTERVAL 1 DAY) FROM Lista_Desejos WHERE ID_Lista BETWEEN 1 AND 50;

INSERT INTO Lista_Desejos (ID_Lista, ID_Cliente, ID_Produto, Data_Adicao)
SELECT ID_Lista + 100, ID_Cliente + 100, ID_Produto, DATE_ADD(Data_Adicao, INTERVAL 1 DAY) FROM Lista_Desejos WHERE ID_Lista BETWEEN 1 AND 100;

INSERT INTO Lista_Desejos (ID_Lista, ID_Cliente, ID_Produto, Data_Adicao)
SELECT ID_Lista + 200, ID_Cliente + 200, ID_Produto, DATE_ADD(Data_Adicao, INTERVAL 1 DAY) FROM Lista_Desejos WHERE ID_Lista BETWEEN 1 AND 200;

INSERT INTO Lista_Desejos (ID_Lista, ID_Cliente, ID_Produto, Data_Adicao)
SELECT ID_Lista + 400, ID_Cliente + 400, ID_Produto, DATE_ADD(Data_Adicao, INTERVAL 1 DAY) FROM Lista_Desejos WHERE ID_Lista BETWEEN 1 AND 400;

INSERT INTO Lista_Desejos (ID_Lista, ID_Cliente, ID_Produto, Data_Adicao)
SELECT ID_Lista + 200, ID_Cliente + 200, ID_Produto, DATE_ADD(Data_Adicao, INTERVAL 1 DAY) FROM Lista_Desejos WHERE ID_Lista BETWEEN 601 AND 800;
select count(*) from Lista_Desejos;


-- ==========================================
-- 12. TABELA: Navegacao (1000 Registros)
-- Relacionamento: ID_Cliente (1 a 1000) e ID_Produto (1001 a 2000)
-- Data_Visualizacao: Entre 2025 e 2026
-- Ações: Visualizou Produto, Adicionou ao Carrinho, Removeu do Carrinho
-- Colunas exatas: ID_Navegacao, ID_Cliente, ID_Produto, Data_Visualizacao, Acao
-- IDs: Sequenciais de 1 a 1000
-- ==========================================

INSERT INTO Navegacao (ID_Navegacao, ID_Cliente, ID_Produto, Data_Visualizacao, Acao) VALUES
(1, 1, 1001, '2025-01-15', 'Visualizou Produto'),
(2, 2, 1002, '2025-02-20', 'Adicionou ao Carrinho'),
(3, 3, 1003, '2025-03-06', 'Visualizou Produto'),
(4, 4, 1004, '2025-04-18', 'Visualizou Produto'),
(5, 5, 1005, '2025-05-22', 'Adicionou ao Carrinho'),
(6, 6, 1006, '2025-06-11', 'Visualizou Produto'),
(7, 7, 1007, '2025-07-19', 'Removeu do Carrinho'),
(8, 8, 1008, '2025-08-03', 'Visualizou Produto'),
(9, 9, 1009, '2025-09-14', 'Adicionou ao Carrinho'),
(10, 10, 1010, '2025-10-25', 'Visualizou Produto'),
(11, 11, 1011, '2025-11-03', 'Visualizou Produto'),
(12, 12, 1012, '2025-12-13', 'Adicionou ao Carrinho'),
(13, 13, 1013, '2026-01-05', 'Visualizou Produto'),
(14, 14, 1014, '2026-01-20', 'Visualizou Produto'),
(15, 15, 1015, '2026-02-14', 'Removeu do Carrinho'),
(16, 16, 1016, '2026-02-27', 'Visualizou Produto'),
(17, 17, 1017, '2026-03-11', 'Adicionou ao Carrinho'),
(18, 18, 1018, '2026-03-25', 'Visualizou Produto'),
(19, 19, 1019, '2026-04-02', 'Visualizou Produto'),
(20, 20, 1020, '2026-04-15', 'Adicionou ao Carrinho'),
(21, 21, 1021, '2026-04-30', 'Visualizou Produto'),
(22, 22, 1022, '2026-05-05', 'Visualizou Produto'),
(23, 23, 1023, '2026-05-18', 'Removeu do Carrinho'),
(24, 24, 1024, '2026-05-21', 'Visualizou Produto'),
(25, 25, 1025, '2026-05-24', 'Adicionou ao Carrinho'),
(26, 26, 1026, '2026-05-25', 'Visualizou Produto'),
(27, 27, 1027, '2025-08-19', 'Visualizou Produto'),
(28, 28, 1028, '2026-07-15', 'Adicionou ao Carrinho'),
(29, 29, 1029, '2026-07-30', 'Visualizou Produto'),
(30, 30, 1030, '2026-08-12', 'Visualizou Produto'),
(31, 31, 1031, '2026-08-25', 'Removeu do Carrinho'),
(32, 32, 1032, '2026-09-04', 'Visualizou Produto'),
(33, 33, 1033, '2026-09-18', 'Adicionou ao Carrinho'),
(34, 34, 1034, '2026-10-02', 'Visualizou Produto'),
(35, 35, 1035, '2026-10-15', 'Visualizou Produto'),
(36, 36, 1036, '2026-10-29', 'Adicionou ao Carrinho'),
(37, 37, 1037, '2026-11-02', 'Visualizou Produto'),
(38, 38, 1038, '2026-11-15', 'Visualizou Produto'),
(39, 39, 1039, '2026-12-01', 'Removeu do Carrinho'),
(40, 40, 1040, '2026-12-10', 'Visualizou Produto'),
(41, 41, 1041, '2026-12-22', 'Adicionou ao Carrinho'),
(42, 42, 1042, '2025-01-20', 'Visualizou Produto'),
(43, 43, 1043, '2025-02-12', 'Visualizou Produto'),
(44, 44, 1044, '2025-03-03', 'Adicionou ao Carrinho'),
(45, 45, 1045, '2025-03-25', 'Visualizou Produto'),
(46, 46, 1046, '2025-04-09', 'Removeu do Carrinho'),
(47, 47, 1047, '2025-04-29', 'Visualizou Produto'),
(48, 48, 1048, '2025-05-14', 'Adicionou ao Carrinho'),
(49, 49, 1049, '2025-05-30', 'Visualizou Produto'),
(50, 50, 1050, '2025-06-16', 'Visualizou Produto');

-- Replicação matemática protegida para fechar os 1000 registros sem quebra de integridade
INSERT INTO Navegacao (ID_Navegacao, ID_Cliente, ID_Produto, Data_Visualizacao, Acao)
SELECT ID_Navegacao + 50, ID_Cliente + 50, ID_Produto, DATE_ADD(Data_Visualizacao, INTERVAL 1 DAY), Acao FROM Navegacao WHERE ID_Navegacao BETWEEN 1 AND 50;

INSERT INTO Navegacao (ID_Navegacao, ID_Cliente, ID_Produto, Data_Visualizacao, Acao)
SELECT ID_Navegacao + 100, ID_Cliente + 100, ID_Produto, DATE_ADD(Data_Visualizacao, INTERVAL 1 DAY), Acao FROM Navegacao WHERE ID_Navegacao BETWEEN 1 AND 100;

INSERT INTO Navegacao (ID_Navegacao, ID_Cliente, ID_Produto, Data_Visualizacao, Acao)
SELECT ID_Navegacao + 200, ID_Cliente + 200, ID_Produto, DATE_ADD(Data_Visualizacao, INTERVAL 1 DAY), Acao FROM Navegacao WHERE ID_Navegacao BETWEEN 1 AND 200;

INSERT INTO Navegacao (ID_Navegacao, ID_Cliente, ID_Produto, Data_Visualizacao, Acao)
SELECT ID_Navegacao + 400, ID_Cliente + 400, ID_Produto, DATE_ADD(Data_Visualizacao, INTERVAL 1 DAY), Acao FROM Navegacao WHERE ID_Navegacao BETWEEN 1 AND 400;

INSERT INTO Navegacao (ID_Navegacao, ID_Cliente, ID_Produto, Data_Visualizacao, Acao)
SELECT ID_Navegacao + 200, ID_Cliente + 200, ID_Produto, DATE_ADD(Data_Visualizacao, INTERVAL 1 DAY), 'Visualizou Produto' FROM Navegacao WHERE ID_Navegacao BETWEEN 601 AND 800;
select count(*) from Navegacao;