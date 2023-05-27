-- DROP user IF EXISTS jpestevao;


--- Criação do usuario jpestevao dono do BD UVV.

 CREATE user jpestevao WITH

 SUPERUSER

 INHERIT

 CREATEDB

 CREATEROLE

 REPLICATION

 ENCRYPTED PASSWORD '$1$xqNB5ctg$DLQ0sQv4jngw5zSNIzmIB0';

COMMENT ON ROLE jpestevao
IS 'Este é um usuário administrativo do BD UVV.';




-- DROP DATABASE IF EXISTS uvv;



--- Criação do BD UVV onde sera armazenado as tabelas do projeto Lojas UVV.


create database uvv

with

owner = "jpestevao"

template = template0

encoding = 'UTF8'

lc_collate = 'pt_BR.UTF-8'

lc_ctype = 'pt_BR.UTF-8'

allow_connections = true;


COMMENT ON DATABASE uvv
IS 'Banco de Dados UVV.';



--Garante privilegios ao usuario jpestevao

GRANT ALL PRIVILEGES ON DATABASE uvv TO jpestevao;




--- Acesso ao BD UVV com o Usuário jpestevao.

\c "dbname=uvv user=jpestevao password=$1$xqNB5ctg$DLQ0sQv4jngw5zSNIzmIB0";





-- DROP SCHEMA IF EXISTS Lojas;


--- Criação do schema Lojas onde sera inserido as tabelas.

CREATE SCHEMA Lojas

AUTHORIZATION jpestevao;

COMMENT ON SCHEMA Lojas

   IS 'Schemas Lojas.';





ALTER USER jpestevao

SET SEARCH_PATH TO lojas, "$user", public;



--- Criação da tabela produtos.


CREATE TABLE Lojas.produtos (
                produto_id NUMERIC(38) NOT NULL,
       nome VARCHAR(255) NOT NULL,
       preco_unitario NUMERIC(10,2),
       detalhes BYTEA,
       imagem BYTEA,
       imagem_mime_type VARCHAR(512),
       imagem_arquivo VARCHAR(512),
       imagem_charset VARCHAR(512),
       imagem_ultima_atualizacao DATE,
       CONSTRAINT produtos_pk PRIMARY KEY (produto_id)
);

ALTER TABLE Lojas.produtos
ADD CONSTRAINT preco_check
  CHECK (preco_unitario >= 0);

COMMENT ON TABLE Lojas.produtos
IS 'Esta tabela armazena informações dos produtos disponíveis na loja.';

COMMENT ON COLUMN Lojas.produtos.produto_id IS 'Identificador do produto (chave primaria)';
COMMENT ON COLUMN Lojas.produtos.nome IS 'Nome do produto';
COMMENT ON COLUMN Lojas.produtos.preco_unitario IS 'Preço unitário do produto';
COMMENT ON COLUMN Lojas.produtos.detalhes IS 'Detalhes sobre o produto';
COMMENT ON COLUMN Lojas.produtos.imagem IS 'Dados binarios armazenados da imagem';
COMMENT ON COLUMN Lojas.produtos.imagem_mime_type IS 'Identificador do tipo de midia e formato de dados da imagem';
COMMENT ON COLUMN Lojas.produtos.imagem_arquivo IS 'Nome do arquivo da imagem';
COMMENT ON COLUMN Lojas.produtos.imagem_charset IS 'Charset da imagem';
COMMENT ON COLUMN Lojas.produtos.imagem_ultima_atualizacao IS 'Data e hora da última atualização da imagem';


--- Criação da tabela lojas.


CREATE TABLE Lojas.lojas (
       loja_id NUMERIC(38) NOT NULL,
       nome VARCHAR(255) NOT NULL,
       endereco_web VARCHAR(100),
       endereco_fisico VARCHAR(512),
       latitude NUMERIC,
       longitude NUMERIC,
       logo BYTEA,
       logo_mime_type VARCHAR(512),
       logo_arquivo VARCHAR(512),
       logo_charset VARCHAR(512),
       logo_ultima_atualizacao DATE,
       CONSTRAINT lojas_pk PRIMARY KEY (loja_id)
);

ALTER TABLE Lojas.lojas
ADD CONSTRAINT endereco_check
CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);


COMMENT ON TABLE Lojas.lojas
IS 'Esta tabela armazena informações das lojas cadastradas.';

COMMENT ON COLUMN Lojas.lojas.loja_id IS 'Identificador da loja ( chave primaria)';
COMMENT ON COLUMN Lojas.lojas.nome IS 'Nome da loja';
COMMENT ON COLUMN Lojas.lojas.endereco_web IS 'Endereço web da loja';
COMMENT ON COLUMN Lojas.lojas.endereco_fisico IS 'Endereço fisico da loja';
COMMENT ON COLUMN Lojas.lojas.latitude IS 'Localização da latitude da loja';
COMMENT ON COLUMN Lojas.lojas.longitude IS 'Localização da longitude da loja';
COMMENT ON COLUMN Lojas.lojas.logo IS 'Dados binarios armazenados da logo';
COMMENT ON COLUMN Lojas.lojas.logo_mime_type IS 'Identificador do tipo de midia e formato de dados da logo';
COMMENT ON COLUMN Lojas.lojas.logo_arquivo IS 'Nome do arquivo do logo';
COMMENT ON COLUMN Lojas.lojas.logo_charset IS 'Charset do logo';
COMMENT ON COLUMN Lojas.lojas.logo_ultima_atualizacao IS 'Data da última atualização do logo';


--- Criação da tabela estoques.


CREATE TABLE Lojas.estoques (
       estoque_id NUMERIC(38) NOT NULL,
       loja_id NUMERIC(38) NOT NULL,
       produto_id NUMERIC(38) NOT NULL,
       quantidade NUMERIC(38) NOT NULL,
       CONSTRAINT estoques_pk PRIMARY KEY (estoque_id)
);

COMMENT ON TABLE Lojas.estoques
IS 'Esta tabela armazena informações de estoque dos produtos em cada loja.';

ALTER TABLE Lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES Lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES Lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.estoques
ADD CONSTRAINT quantidade_check
  CHECK (quantidade >= 0);

COMMENT ON COLUMN Lojas.estoques.estoque_id IS 'Identificado do estoque (chave primaria)';
COMMENT ON COLUMN Lojas.estoques.loja_id IS 'Identificador da loja (chave estrangeira referenciando a tabela lojas)';
COMMENT ON COLUMN Lojas.estoques.produto_id IS 'Identificador do produto (chave estrangeira referenciando a tabela produtos)';
COMMENT ON COLUMN Lojas.estoques.quantidade IS 'Quantidade disponível em estoque';


--- Criação da tabela clientes.


CREATE TABLE Lojas.clientes (
       cliente_id NUMERIC(38) NOT NULL,
       email VARCHAR(255) NOT NULL,
       nome VARCHAR(255) NOT NULL,
       telefone1 VARCHAR(20),
       telefone2 VARCHAR(20),
       telefone3 VARCHAR(20),
       CONSTRAINT clientes_pk PRIMARY KEY (cliente_id)
);

COMMENT ON TABLE Lojas.clientes
IS 'Esta tabela armazena informações dos clientes da Loja.';

COMMENT ON COLUMN Lojas.clientes.cliente_id IS 'Identificador do cliente (chave primária)';
COMMENT ON COLUMN Lojas.clientes.email IS 'Endereço de e-mail do cliente';
COMMENT ON COLUMN Lojas.clientes.nome IS 'Nome do cliente';
COMMENT ON COLUMN Lojas.clientes.telefone1 IS 'Primeiro telefone do cliente';
COMMENT ON COLUMN Lojas.clientes.telefone2 IS 'Segundo telefone do cliente';
COMMENT ON COLUMN Lojas.clientes.telefone3 IS 'Terceiro telefone do cliente';


--- Criação da tabela envios.


CREATE TABLE Lojas.envios (
       envio_id NUMERIC(38) NOT NULL,
       loja_id NUMERIC(38) NOT NULL,
       cliente_id NUMERIC(38) NOT NULL,
       endereco_entrega VARCHAR(512) NOT NULL,
       status VARCHAR(15) NOT NULL,
       CONSTRAINT envios_pk PRIMARY KEY (envio_id)
);

ALTER TABLE Lojas.envios
ADD CONSTRAINT envios_status_check
CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

COMMENT ON TABLE Lojas.envios
IS 'Esta tabela armazena informações sobre os envios de produtos para os clientes.';

ALTER TABLE Lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES Lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES Lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

COMMENT ON COLUMN Lojas.envios.envio_id IS 'Identificador do envio ( chave primaria)';
COMMENT ON COLUMN Lojas.envios.loja_id IS 'Identificador da loja associado a tabela envios (chave estrangeira referenciando a tabela lojas)';
COMMENT ON COLUMN Lojas.envios.cliente_id IS 'Identificador do cliente associado a tabela envios (chave estrangeira referenciando a tabela clientes)';
COMMENT ON COLUMN Lojas.envios.endereco_entrega IS 'Endereço de entrega do envio';
COMMENT ON COLUMN Lojas.envios.status IS 'Status do envio';


--- Criação da tabela pedidos.


CREATE TABLE Lojas.pedidos (
       pedido_id NUMERIC(38) NOT NULL,
       data_hora TIMESTAMP NOT NULL,
       cliente_id NUMERIC(38) NOT NULL,
       status VARCHAR(15) NOT NULL,
       loja_id NUMERIC(38) NOT NULL,
       CONSTRAINT pedidos_pk PRIMARY KEY (pedido_id)
);

ALTER TABLE Lojas.pedidos
ADD CONSTRAINT pedidos_status_check
CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));


COMMENT ON TABLE Lojas.pedidos
IS 'Esta tabela armazena informações sobre os pedidos realizados pelos clientes.';

ALTER TABLE Lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES Lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES Lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

COMMENT ON COLUMN Lojas.pedidos.pedido_id IS 'Identificador do pedido (chave primaria)';
COMMENT ON COLUMN Lojas.pedidos.data_hora IS 'Data e hora do pedido';
COMMENT ON COLUMN Lojas.pedidos.cliente_id IS 'Identificador do cliente associado ao pedido (chave estrangeira referenciando a tabela clientes)';
COMMENT ON COLUMN Lojas.pedidos.status IS 'Status do pedido';
COMMENT ON COLUMN Lojas.pedidos.loja_id IS 'Identificador da loja onde o pedido foi realizado (chave estrangeira referenciando a tabela lojas)';


--- Criação da tabela pedidos_itens.


CREATE TABLE Lojas.pedidos_itens (
       pedido_id NUMERIC(38) NOT NULL,
       produto_id NUMERIC(38) NOT NULL,
       numero_da_linha NUMERIC(38) NOT NULL,
       preco_unitario NUMERIC(10,2) NOT NULL,
       quantidade NUMERIC(38) NOT NULL,
       envio_id NUMERIC(38),
       CONSTRAINT pedidos_itens_pk PRIMARY KEY (pedido_id, produto_id)
);

COMMENT ON TABLE Lojas.pedidos_itens
IS 'Esta tabela armazena os itens de um pedido em uma loja.';

ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT quantidade_check
  CHECK (quantidade >= 0);

ALTER TABLE Lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES Lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES Lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES Lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


COMMENT ON COLUMN Lojas.pedidos_itens.pedido_id IS 'Identificador do pedido (chave composta (PK e FK) referenciando a tabela pedidos)';
COMMENT ON COLUMN Lojas.pedidos_itens.produto_id IS 'Identificador do produto (chave composta (PK e FK) referenciando a tabela produtos)';
COMMENT ON COLUMN Lojas.pedidos_itens.numero_da_linha IS 'Número da linha do item no pedido';
COMMENT ON COLUMN Lojas.pedidos_itens.preco_unitario IS 'Preço unitário do produto no momento do pedido';
COMMENT ON COLUMN Lojas.pedidos_itens.quantidade IS 'Quantidade solicitada do produto';
COMMENT ON COLUMN Lojas.pedidos_itens.envio_id IS 'Identificador do envio (chave estrangeira referenciando a tabela envios)';