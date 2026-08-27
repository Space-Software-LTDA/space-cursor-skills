# Exemplo — matriz lacunas (ONESET Admin)

Referência para [lovable-vs-local.md](../lovable-vs-local.md). **Não** colar cegamente em outras tasks.

| Item | Protótipo | Local | Lacuna |
| --- | --- | --- | --- |
| UI `/admin` | ✅ | ❌ | Rotas + layout **light** (não dark Lovable) |
| BFF `/api/admin/*` | — | ❌ | Proxy JWT |
| RBAC superadmin | — | ❌ | roles, guard, seed |
| Dashboard KPIs | ✅ | ❌ | GET /admin/dashboard + mocks |
| Campanhas → Ver | ✅ redirect ficha | ❌ | userId + rota ficha |
| Profissões + tokens | ✅ | ⚠️ | CRUD parcial; falta admin UI |
| Tags Google | ✅ | ❌ | Colunas + aba |
| Login Como | ✅ | ❌ | impersonate JWT |

Task completa: `{projeto-cliente}/.task/oneset/admin-oneset.md`
