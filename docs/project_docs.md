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