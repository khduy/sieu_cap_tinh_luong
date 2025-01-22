## GitHub Pages Deployment

The project is configured for automatic deployment to GitHub Pages using GitHub Actions. The deployment workflow:

1. Triggers on pushes to the main branch
2. Builds the Flutter web app
3. Deploys to GitHub Pages

The deployed site is available at: https://your-username.github.io/your-repository-name/

### Deployment Configuration
- Workflow file: `.github/workflows/deploy.yml`
- Base href: `/your-repository-name/`
- Build command: `flutter build web --base-href "/your-repository-name/"`

### Manual Deployment
To manually trigger deployment:
1. Go to Actions tab in GitHub
2. Select "Deploy to GitHub Pages" workflow
3. Click "Run workflow" 