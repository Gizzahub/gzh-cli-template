module github.com/gizzahub/gzh-cli-__PROJECT_NAME__

go 1.25.7

require github.com/gizzahub/gzh-cli-core v0.1.0

require gopkg.in/yaml.v3 v3.0.1 // indirect

// TODO: Remove this replace directive after publishing gzh-cli-core
replace github.com/gizzahub/gzh-cli-core => ../gzh-cli-core
