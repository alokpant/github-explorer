# README

A simple project to list 30 Github Public repositories. Stack that were used are:
- Rails
- TailwindCSS for Frontend
- Minitest for Testing

To run the project:

Install dependencies:
```
bundle install
```

```
./bin/dev
```

To run tests:
```
bin/rails test
```

Limitation:
- It only return 30 repositories even if there are more than 30. No pagination is implemented yet.
- Sorting based on stargazers or watchers is also not possible as the field sort is [deprecated](https://docs.github.com/en/free-pro-team@latest/rest/search/search?apiVersion=2022-11-28#search-code)