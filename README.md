# Avel Bundle

All Avel plugins in one installer for macOS and Windows.

| | |
|---|---|
| **macOS** (VST3 + AU, Apple Silicon & Intel) | [Avel-Bundle-macOS.pkg](https://github.com/johntok0001/AvelBundle/releases/latest/download/Avel-Bundle-macOS.pkg) |
| **Windows** (VST3, 64-bit) | [Avel-Bundle-Windows-Setup.exe](https://github.com/johntok0001/AvelBundle/releases/latest/download/Avel-Bundle-Windows-Setup.exe) |
| Both in one archive | [Avel-Bundle.zip](https://github.com/johntok0001/AvelBundle/releases/latest/download/Avel-Bundle.zip) |

Avel Tape · Avel Time · Avel Verb · Avel EQ · Avel Dynamic · Avel Ess · Avel Ember · Avel Apex

These links always point to the newest build and can be used on the website as is.

---

## Как это работает

Этот репозиторий не хранит код плагинов. При каждой сборке GitHub берёт свежий код
из репозиториев плагинов (список в `plugins.json`), собирает их для Mac и Windows и
упаковывает в два установщика. Результат появляется на странице **Releases**.

Сборка запускается:
- при любом изменении в этом репозитории;
- вручную: **Actions → Build Avel Bundle → Run workflow**;
- каждую ночь сама, если в каком-то плагине появились изменения.

Поменяли что-то в плагине — ничего делать не нужно: к утру общий установщик обновится
(или запустите сборку вручную, чтобы не ждать).

**Новый плагин** — добавить строку в `plugins.json`.
**Новая версия пака** — поменять число в `VERSION`.

## Подпись Apple (по желанию)

Без подписи macOS при первом запуске установщика попросит подтвердить его в
«Системные настройки → Конфиденциальность и безопасность → Всё равно открыть».
Когда появится аккаунт Apple Developer, добавьте в **Settings → Secrets and variables → Actions**:

| Secret | Что это |
|---|---|
| `MACOS_CERTS_P12` | сертификаты *Developer ID Application* и *Developer ID Installer*, экспортированные в один .p12 и закодированные в base64 |
| `MACOS_CERTS_PASSWORD` | пароль от этого .p12 |
| `APPLE_ID` | e-mail Apple ID |
| `APPLE_TEAM_ID` | Team ID из developer.apple.com |
| `APPLE_APP_PASSWORD` | пароль приложения с appleid.apple.com |

Со следующей сборки установщик будет подписан и нотаризован, предупреждение исчезнет.
