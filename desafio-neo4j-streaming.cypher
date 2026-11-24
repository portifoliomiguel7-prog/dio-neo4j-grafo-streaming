// DESAFIO DIO - Neo4j: serviço de streaming
// Dados fictícios para fins didáticos.
// Execute em um banco de estudos. No Neo4j Browser/Query, execute cada
// instrução terminada em ; separadamente, na ordem apresentada.
// Este script é repetível: MERGE identifica nós por label+id e relacionamentos
// pelos respectivos pares de nós e tipo.

// 1. CONSTRAINTS - um ID único por tipo de entidade
CREATE CONSTRAINT user_id_unique IF NOT EXISTS
FOR (n:User) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT movie_id_unique IF NOT EXISTS
FOR (n:Movie) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT series_id_unique IF NOT EXISTS
FOR (n:Series) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT genre_id_unique IF NOT EXISTS
FOR (n:Genre) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT actor_id_unique IF NOT EXISTS
FOR (n:Actor) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT director_id_unique IF NOT EXISTS
FOR (n:Director) REQUIRE n.id IS UNIQUE;

// 2. NÓS - 10 usuários
UNWIND [
  {id: 1, name: 'Ana Silva', email: 'ana@example.com'},
  {id: 2, name: 'Bruno Costa', email: 'bruno@example.com'},
  {id: 3, name: 'Carla Martins', email: 'carla@example.com'},
  {id: 4, name: 'Diego Lima', email: 'diego@example.com'},
  {id: 5, name: 'Elisa Rocha', email: 'elisa@example.com'},
  {id: 6, name: 'Felipe Alves', email: 'felipe@example.com'},
  {id: 7, name: 'Gabriela Nunes', email: 'gabriela@example.com'},
  {id: 8, name: 'Hugo Pereira', email: 'hugo@example.com'},
  {id: 9, name: 'Isabela Souza', email: 'isabela@example.com'},
  {id: 10, name: 'João Ribeiro', email: 'joao@example.com'}
] AS dados
MERGE (n:User {id: dados.id})
SET n.name = dados.name, n.email = dados.email;

// 2. NÓS - 10 filmes
UNWIND [
  {id: 1, title: 'Horizonte de Titã', releaseYear: 2021},
  {id: 2, title: 'Cidade de Vidro', releaseYear: 2022},
  {id: 3, title: 'Ecos do Futuro', releaseYear: 2020},
  {id: 4, title: 'O Último Portal', releaseYear: 2019},
  {id: 5, title: 'Além da Nebulosa', releaseYear: 2023},
  {id: 6, title: 'O Código Perdido', releaseYear: 2021},
  {id: 7, title: 'Sombras de Aurora', releaseYear: 2024},
  {id: 8, title: 'A Jornada Secreta', releaseYear: 2020},
  {id: 9, title: 'A Última Chave', releaseYear: 2022},
  {id: 10, title: 'Rota Infinita', releaseYear: 2025}
] AS dados
MERGE (n:Movie {id: dados.id})
SET n.title = dados.title, n.releaseYear = dados.releaseYear;

// 2. NÓS - 10 séries
UNWIND [
  {id: 1, title: 'Arquivos de Órion', seasons: 2},
  {id: 2, title: 'Zona Zero', seasons: 3},
  {id: 3, title: 'Ecos da Memória', seasons: 1},
  {id: 4, title: 'Linhas do Tempo', seasons: 4},
  {id: 5, title: 'Cidade Oculta', seasons: 2},
  {id: 6, title: 'A Fronteira', seasons: 3},
  {id: 7, title: 'Laboratório 13', seasons: 1},
  {id: 8, title: 'Sinais da Noite', seasons: 2},
  {id: 9, title: 'Fragmentos', seasons: 3},
  {id: 10, title: 'Crônicas do Amanhã', seasons: 2}
] AS dados
MERGE (n:Series {id: dados.id})
SET n.title = dados.title, n.seasons = dados.seasons;

// 2. NÓS - 10 gêneros
UNWIND [
  {id: 1, name: 'Ficção científica'},
  {id: 2, name: 'Ação'},
  {id: 3, name: 'Drama'},
  {id: 4, name: 'Romance'},
  {id: 5, name: 'Comédia'},
  {id: 6, name: 'Mistério'},
  {id: 7, name: 'Suspense'},
  {id: 8, name: 'Fantasia'},
  {id: 9, name: 'Documentário'},
  {id: 10, name: 'Aventura'}
] AS dados
MERGE (n:Genre {id: dados.id})
SET n.name = dados.name;

// 2. NÓS - 10 atores
UNWIND [
  {id: 1, name: 'Alice Monteiro'},
  {id: 2, name: 'Bruno Caires'},
  {id: 3, name: 'Clara Mendes'},
  {id: 4, name: 'Daniel Costa'},
  {id: 5, name: 'Elisa Prado'},
  {id: 6, name: 'Fábio Nunes'},
  {id: 7, name: 'Giovana Lima'},
  {id: 8, name: 'Heitor Pires'},
  {id: 9, name: 'Isabela Moura'},
  {id: 10, name: 'João Batista'}
] AS dados
MERGE (n:Actor {id: dados.id})
SET n.name = dados.name;

// 2. NÓS - 10 diretores
UNWIND [
  {id: 1, name: 'Camila Rocha'},
  {id: 2, name: 'Rafael Martins'},
  {id: 3, name: 'Helena Castro'},
  {id: 4, name: 'Luiza Tavares'},
  {id: 5, name: 'Marcos Duarte'},
  {id: 6, name: 'Beatriz Santana'},
  {id: 7, name: 'Renato Oliveira'},
  {id: 8, name: 'Patrícia Freitas'},
  {id: 9, name: 'Silvia Azevedo'},
  {id: 10, name: 'Pedro Almeida'}
] AS dados
MERGE (n:Director {id: dados.id})
SET n.name = dados.name;

// 3. RELACIONAMENTOS - catálogo sintético, mas interconectado
// Para cada i de 1 a 10:
// - User i assiste a Movie i, Series i e Movie seguinte (circular);
// - Actor i atua em Movie i, Series i e Movie seguinte;
// - Director i dirige Movie i e Series i;
// - Movie i pertence a Genre i e ao Genre seguinte;
// - Series i pertence a Genre i.
UNWIND range(1, 10) AS i
WITH i, (i % 10) + 1 AS nextId
MATCH (u:User {id: i})
MATCH (m:Movie {id: i})
MATCH (s:Series {id: i})
MATCH (a:Actor {id: i})
MATCH (d:Director {id: i})
MATCH (g:Genre {id: i})
MATCH (mNext:Movie {id: nextId})
MATCH (gNext:Genre {id: nextId})
MERGE (u)-[w1:WATCHED]->(m)
SET w1.rating = 3.0 + (i % 5) * 0.5
MERGE (u)-[w2:WATCHED]->(s)
SET w2.rating = 3.5 + (i % 4) * 0.5
MERGE (u)-[w3:WATCHED]->(mNext)
SET w3.rating = 3.0 + (i % 3) * 0.5
MERGE (a)-[:ACTED_IN]->(m)
MERGE (a)-[:ACTED_IN]->(s)
MERGE (a)-[:ACTED_IN]->(mNext)
MERGE (d)-[:DIRECTED]->(m)
MERGE (d)-[:DIRECTED]->(s)
MERGE (m)-[:IN_GENRE]->(g)
MERGE (m)-[:IN_GENRE]->(gNext)
MERGE (s)-[:IN_GENRE]->(g);

// 4. VALIDAÇÃO - 60 nós esperados, 10 em cada label
MATCH (n)
UNWIND labels(n) AS label
RETURN label AS tipo, count(*) AS quantidade
ORDER BY tipo;

// 4. VALIDAÇÃO - 110 relacionamentos esperados:
// WATCHED 30, ACTED_IN 30, DIRECTED 20, IN_GENRE 30
MATCH ()-[r]->()
RETURN type(r) AS relacionamento, count(*) AS quantidade
ORDER BY relacionamento;

// 4. VISUALIZAÇÃO - no Neo4j Browser/Query, use a exibição de grafo
MATCH p=()-[r]->()
RETURN p
LIMIT 150;

// 4. CONSULTA EXEMPLO - notas dos filmes/séries assistidos por uma pessoa
MATCH (u:User {id: 1})-[w:WATCHED]->(obra)
RETURN u.name AS usuario, obra.title AS titulo,
       labels(obra)[0] AS tipo, w.rating AS nota
ORDER BY nota DESC;
