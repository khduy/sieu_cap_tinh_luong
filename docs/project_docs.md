## GitHub Pages Deployment

The project is configured for automatic deployment to GitHub Pages using GitHub Actions. The deployment workflow:

1. Triggers on pushes to the master branch
2. Builds the Flutter web app
3. Deploys to GitHub Pages

The deployed site is available at: https://[username].github.io/sieu_cap_tinh_luong/

### Deployment Configuration
- Workflow file: `.github/workflows/deploy.yml`
- Base href: `/sieu_cap_tinh_luong/`
- Build command: `flutter build web --base-href "/sieu_cap_tinh_luong/"`

### Manual Deployment
To manually trigger deployment:
1. Go to Actions tab in GitHub
2. Select "Deploy to GitHub Pages" workflow
3. Click "Run workflow"

### Notes
- The web app uses the latest Flutter web initialization method
- Deployment triggers automatically on pushes to the master branch
- The site is served from the /sieu_cap_tinh_luong/ path

### Environment Variables
The following secrets need to be configured in GitHub repository settings:
- `GEMINI_API_KEY`: The API key for Gemini services

### Configuration Steps
1. Go to repository Settings > Secrets and variables > Actions
2. Add the following secrets:
   - GEMINI_API_KEY: Your Gemini API key
3. The deployment workflow will automatically use these secrets during build

### Security Notes
- API keys and other sensitive data are stored as GitHub Secrets
- Secrets are encrypted and only exposed to GitHub Actions during build
- The web app receives the API key through build-time environment variables 