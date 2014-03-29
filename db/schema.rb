# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140329164221) do

  create_table "addresses", force: true do |t|
    t.string   "tipo",       limit: 5,   null: false
    t.string   "logradouro", limit: 100, null: false
    t.string   "bairro",     limit: 100, null: false
    t.string   "estado",     limit: 2,   null: false
    t.string   "cidade",     limit: 100, null: false
    t.string   "cep",        limit: 10,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["cep"], name: "index_addresses_on_cep", unique: true

  create_table "carriers", force: true do |t|
    t.string   "cnpj",                limit: 18,  null: false
    t.string   "nome",                limit: 100, null: false
    t.string   "fantasia",            limit: 100, null: false
    t.string   "inscricao_estadual",  limit: 20
    t.string   "inscricao_municipal", limit: 20
    t.string   "endereco",            limit: 100, null: false
    t.string   "numero",              limit: 20,  null: false
    t.string   "complemento",         limit: 100
    t.string   "bairro",              limit: 100, null: false
    t.string   "cidade",              limit: 100, null: false
    t.string   "estado",              limit: 2,   null: false
    t.string   "cep",                 limit: 10,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.string   "cpf_cnpj",            limit: 18,  null: false
    t.string   "nome",                limit: 100, null: false
    t.string   "fantasia",            limit: 100, null: false
    t.string   "inscricao_estadual",  limit: 20
    t.string   "inscricao_municipal", limit: 20
    t.string   "endereco",            limit: 100, null: false
    t.string   "numero",              limit: 20,  null: false
    t.string   "complemento",         limit: 100
    t.string   "bairro",              limit: 100, null: false
    t.string   "cidade",              limit: 100, null: false
    t.string   "estado",              limit: 2,   null: false
    t.string   "cep",                 limit: 10,  null: false
    t.integer  "tipo_pessoa",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "nome",        limit: 30,  null: false
    t.integer  "tipo",                    null: false
    t.string   "fone",        limit: 15
    t.string   "complemento", limit: 100
    t.integer  "person_id",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drivers", force: true do |t|
    t.string   "cpf",          limit: 14,  null: false
    t.string   "nome",         limit: 100, null: false
    t.string   "fantasia",     limit: 100, null: false
    t.string   "endereco",     limit: 100, null: false
    t.string   "numero",       limit: 20,  null: false
    t.string   "complemento",  limit: 100
    t.string   "bairro",       limit: 100, null: false
    t.string   "cidade",       limit: 100, null: false
    t.string   "estado",       limit: 2,   null: false
    t.string   "cep",          limit: 10,  null: false
    t.string   "rg",           limit: 20,  null: false
    t.string   "cnh",          limit: 20,  null: false
    t.integer  "categoria",                null: false
    t.date     "validade_cnh",             null: false
    t.date     "data_emissao",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: true do |t|
    t.string   "cpf",         limit: 14,  null: false
    t.string   "nome",        limit: 100, null: false
    t.string   "apelido",     limit: 100, null: false
    t.string   "endereco",    limit: 100, null: false
    t.string   "numero",      limit: 20,  null: false
    t.string   "complemento", limit: 100
    t.string   "bairro",      limit: 100, null: false
    t.string   "cidade",      limit: 100, null: false
    t.string   "estado",      limit: 2,   null: false
    t.string   "cep",         limit: 10,  null: false
    t.integer  "tipo",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.string   "cpf_cnpj",    limit: 18,  null: false
    t.string   "nome",        limit: 100, null: false
    t.string   "fantasia",    limit: 100, null: false
    t.integer  "address_id",              null: false
    t.string   "numero",      limit: 15,  null: false
    t.string   "complemento", limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["cpf_cnpj"], name: "index_people_on_cpf_cnpj", unique: true

  create_table "suppliers", force: true do |t|
    t.string   "cpf_cnpj",            limit: 18,  null: false
    t.string   "nome",                limit: 100, null: false
    t.string   "fantasia",            limit: 100, null: false
    t.string   "inscricao_estadual",  limit: 20
    t.string   "inscricao_municipal", limit: 20
    t.string   "endereco",            limit: 100, null: false
    t.string   "numero",              limit: 20,  null: false
    t.string   "complemento",         limit: 100
    t.string   "bairro",              limit: 100, null: false
    t.string   "cidade",              limit: 100, null: false
    t.string   "estado",              limit: 2,   null: false
    t.string   "cep",                 limit: 10,  null: false
    t.integer  "tipo_pessoa",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vehicles", force: true do |t|
    t.string   "marca",                  limit: 20,  null: false
    t.string   "modelo",                 limit: 20,  null: false
    t.integer  "ano",                                null: false
    t.string   "cor",                    limit: 20,  null: false
    t.integer  "tipo_veiculo",                       null: false
    t.string   "municipio_emplacamento", limit: 100, null: false
    t.string   "estado",                 limit: 2,   null: false
    t.string   "renavan",                limit: 20,  null: false
    t.string   "chassi",                 limit: 20,  null: false
    t.string   "capacidade",                         null: false
    t.string   "placa",                  limit: 8,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
