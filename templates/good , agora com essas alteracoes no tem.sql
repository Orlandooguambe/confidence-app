good , agora com essas alteracoes no templante nos formularios de denucia e Reclamacoes ; qual sera a base de dados de todo o sistema ; veja como sera o fluxo vamos organizar melhor vou explicar o que o sistema vai fazer  -1 acesso o link  , tenho 3 opcoes de menu : 1 Fazer Denucia ( com o formulario respectivo para fazer a denucia com respectivos anxos ; 2- reclamacoes( formulario com modelo hibrido(anonimo ou nao e aparecer o campo por nome , contacto ou email) ; 3- Acompanhamento( aqui tera um parte verificar o codigo  e depois vai para um bate papo onde vera a situacao e tambem pode mandar mensagem ; depois temos Painel Adminsrtivo para Rh ou complicee 1-login e passowrd;2- dashboard ( onde tera qauntos casos por dia denucia , reclamacao ); 3- Ver denucias( onde sera possivel responder e por no estado encessaro etc.. ) 4- Reclamacoes (  Mesma coisa etc..) ; 5- Relatorios ; 6- Definicoes ( Perfil( nome gestor , cargo, Alterar Password), aqui  para no admin tera que aparecer opcoes porque vai escolher perfil que tera acesso os campos ; entendeste , outras coisas ter notificacoes para os painel administrativo pode ser via email  para nao perder as denucias , e tera prazo para verificar se da para dar seguimnto ou nao a denucia, oara o colabordaro entrar toda hora verificar se ja esta ou nao , logo que ele submte a denucia pode aparecer a data que ja pode verificar a resposta , etc.. entendeu ?


-- 1. Criar nova tabela temporária com o campo UNIQUE
CREATE TABLE reclamacoes_nova (
    id INTEGER PRIMARY KEY,
    anonimo BOOLEAN DEFAULT TRUE,
    nome VARCHAR(100),
    email VARCHAR(150),
    telefone VARCHAR(30),
    data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descricao TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'Pendente',
    resposta_admin TEXT,
    data_resposta TIMESTAMP,
    respondido_por_id INTEGER,
    codigo_acompanhamento VARCHAR(50) UNIQUE  -- NOVO CAMPO
);

-- ============================
-- TABELA: USUÁRIOS ADMINISTRATIVOS
-- ============================
CREATE TABLE usuarios_admin (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(100),
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash TEXT NOT NULL,
    tipo_perfil VARCHAR(50) CHECK (tipo_perfil IN ('RH', 'Compliance', 'Admin')) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================
-- TABELA: PERMISSÕES DE USUÁRIOS
-- ============================
CREATE TABLE permissoes_usuarios (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios_admin(id) ON DELETE CASCADE,
    pode_ver_denuncias BOOLEAN DEFAULT FALSE,
    pode_ver_reclamacoes BOOLEAN DEFAULT FALSE,
    pode_gerar_relatorios BOOLEAN DEFAULT FALSE
);

-- ============================
-- TABELA: DENÚNCIAS
-- ============================
CREATE TABLE denuncias (
    id SERIAL PRIMARY KEY,
    codigo_acompanhamento VARCHAR(50) UNIQUE NOT NULL,
    data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descricao TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'Pendente',
    data_resposta_prevista DATE,
    resposta_admin TEXT,
    data_resposta TIMESTAMP,
    respondido_por_id INTEGER REFERENCES usuarios_admin(id)
);

-- ============================
-- TABELA: ANEXOS DE DENÚNCIA
-- ============================
CREATE TABLE anexos_denuncia (
    id SERIAL PRIMARY KEY,
    denuncia_id INTEGER REFERENCES denuncias(id) ON DELETE CASCADE,
    caminho_arquivo TEXT NOT NULL,
    nome_arquivo TEXT,
    tipo_arquivo VARCHAR(50),
    enviado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================
-- TABELA: MENSAGENS DE ACOMPANHAMENTO
-- ============================
-- Alterar estrutura para suporte a ambos
CREATE TABLE mensagens_acompanhamento (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(20) CHECK (tipo IN ('colaborador', 'admin')) NOT NULL,
    origem VARCHAR(20) CHECK (origem IN ('denuncia', 'reclamacao')) NOT NULL,
    referencia_id INTEGER NOT NULL,
    mensagem TEXT NOT NULL,
    data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================
-- TABELA: RECLAMAÇÕES
-- ============================

-- ============================
-- TABELA: ANEXOS DE RECLAMAÇÃO
-- ============================
CREATE TABLE anexos_reclamacao (
    id SERIAL PRIMARY KEY,
    reclamacao_id INTEGER REFERENCES reclamacoes(id) ON DELETE CASCADE,
    caminho_arquivo TEXT NOT NULL,
    nome_arquivo TEXT,
    tipo_arquivo VARCHAR(50),
    enviado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================
-- TABELA: NOTIFICAÇÕES DE EMAIL
-- ============================
CREATE TABLE notificacoes_email (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(20) CHECK (tipo IN ('denuncia', 'reclamacao')) NOT NULL,
    referencia_id INTEGER NOT NULL,
    destinatario_email VARCHAR(150),
    enviado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP


    CREATE TABLE logs_acao (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios_admin(id),
    acao TEXT NOT NULL,
    referencia TEXT, -- tipo de item afetado (denuncia, reclamacao...)
    referencia_id INTEGER,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
