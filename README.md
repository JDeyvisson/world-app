# 🌍 World App - Buscador de Países

Um aplicativo móvel desenvolvido em Flutter que permite aos utilizadores explorar, pesquisar e guardar informações sobre todos os países do mundo. A aplicação consome a API [REST Countries](https://restcountries.com/) para obter dados atualizados.

## ✨ Funcionalidades Principais

* **Listagem Completa:** Navegue por uma lista de todos os países, ordenados alfabeticamente pelo nome em português.
* **Pesquisa Inteligente:** Encontre países rapidamente pesquisando por nome (em português ou inglês), capital, moeda, língua ou região.
* **Detalhes Abrangentes:** Toque num país para ver informações detalhadas, incluindo:
    * Bandeira
    * Capital e Região/Sub-região
    * População e Área (formatadas para pt_BR)
    * Moeda e Língua principal
    * Lista de países com quem faz fronteira
* **Sistema de Favoritos:**
    * Marque e desmarque países como favoritos diretamente da lista principal ou da tela de detalhes.
    * Os favoritos são guardados no dispositivo (usando `shared_preferences`) e persistem mesmo após fechar a aplicação.
    * A lista principal ordena automaticamente os países favoritos para o topo.
* **Tradução:** Exibe os nomes dos países em português, recorrendo aos dados de tradução da API.
* **Gestão de Estado:** Utiliza `Provider` para uma gestão de estado reativa e eficiente do sistema de favoritos.

## 🛠️ Tecnologias e Pacotes Utilizados

Este projeto foi construído com **Flutter** e **Dart**. As principais dependências incluem:

* **[provider](https://pub.dev/packages/provider)**: Para a gestão de estado (especificamente para o `FavoritesProvider`).
* **[http](https://pub.dev/packages/http)**: Para realizar chamadas à API REST Countries.
* **[shared_preferences](https://pub.dev/packages/shared_preferences)**: Para armazenar localmente a lista de países favoritos.
* **[intl](https://pub.dev/packages/intl)**: Para formatar números (população e área) no padrão brasileiro.
* **[diacritic](https://pub.dev/packages/diacritic)**: Dependência incluída (provavelmente para ajudar na pesquisa).
* **[flutter_lints](https://pub.dev/packages/flutter_lints)**: Para garantir boas práticas e qualidade de código.

## 🚀 Como Executar

Para executar este projeto localmente, siga os passos abaixo:

1.  **Clone o repositório:**
    ```sh
    git clone [https://github.com/jdeyvisson/world-app.git](https://github.com/jdeyvisson/world-app.git)
    cd world-app
    ```

2.  **Instale as dependências:**
    ```sh
    flutter pub get
    ```

3.  **Execute a aplicação:**
    (Certifique-se de que tem um emulador em execução ou um dispositivo conectado)
    ```sh
    flutter run
    ```
