# Google Cloud setup (one-time, done by you)

You need this before M1 (sign-in). M0 doesn't need it.

1. **Create a project**: https://console.cloud.google.com/ → New project (e.g., `twinpane-drive`).
2. **Enable the Drive API**: APIs & Services → Library → "Google Drive API" → Enable.
3. **OAuth consent screen** (Google Auth Platform → Branding / Audience):
   - User type: **External**; publishing status: **Testing**.
   - Add your own Google account under **Test users**.
   - Data access / scopes: add `https://www.googleapis.com/auth/drive`.
   - In Testing mode no verification is needed, but only listed test users can sign in.
4. **Get a stable extension ID**: after M0, load `dist/` unpacked in `chrome://extensions` and note the ID. M0 adds a `key` to the manifest so the ID never changes between builds.
5. **Create the OAuth client**: Credentials → Create credentials → OAuth client ID → Application type **Chrome Extension** → paste the extension ID.
6. Copy the **client ID** (it ends in `.apps.googleusercontent.com`) and put it in `.env.local` as `VITE_OAUTH_CLIENT_ID=...`. It isn't a secret, but keeping it out of git makes forks easier.

Revoke access at any time: https://myaccount.google.com/connections
