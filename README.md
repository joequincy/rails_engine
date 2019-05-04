# README

The project directions were to implement a JSON-based API using Ruby on Rails. Specification details can be found [in the turingschool repo](https://github.com/turingschool/backend-curriculum-site/blob/58ed85f97ce0b7fc98f944b21528eb6fa0a4aac0/module3/projects/rails_engine.md).

In addition to the project requirements, I wanted to challenge myself to DRY up my code as much as possible by exploring metaprogramming techniques. This project has a lot of endpoints which follow the same outline, so it provided many opportunities to reduce repetition. Since this was a solo project and not graded, it seemed a good place to explore experiments like this. It lead to a much more compact codebase (most controllers need only be declared), however this comes at the cost of readability and is likely not a good path for real-world projects... especially those involving other team members.

I have added thorough comments to the base ApplicationController and its folder siblings ChildResourceModule and FindersModule, which explain how my approach works.

### Setup

This project was built with Ruby 2.4.1, Rails 5.1.7, and Postgresql 11.2
To get started, run:  
`$> bundle install`  
`$> rake db:{create,migrate,import}`

To reset the database and seeds, run  
`$> rake db:reseed`
