# Move Project Repo Template

This is a template for Workshop Students Project Submissions

## ⚠️ Important Notes
- **Do not rename** the `ui` and `move` folders
- **Do not edit** the test files
- All tests must pass for successful deployment

## Getting Started

### 1. Repository Setup
- Click `Use this template` and create a new repository
- Name it: `<YOUR-NAME>-Challenge` (e.g., `AliErcanOzgokce-Challenge`)
- Make sure the repository is **Public**
- Clone the repository:
  ```bash
  git clone <YOUR-REPO-URL>
  cd <YOUR-REPO-NAME>
  ```

### 2. Follow the Implementation Guide
- Read and complete the [STUDENT_GUIDE.md](./STUDENT_GUIDE.md)
- Implement all TODO items in both smart contracts and frontend
- Ensure all tests pass

### 3. Build and Test
```bash
# Build smart contracts
cd move
sui move build
sui move test

# Build frontend
cd ../ui
npm install
npm run build
```

### 4. Configure Your Github Pages Settings ⚠️
In your repository, go to Settings → Pages → Source, and change it from "Deploy from a branch" to "GitHub Actions"

### 5. Deploy and Commit
```bash
git add .
git commit -m "Complete all the TODOs"
git push origin main
```

## Live Deployment

⚠️ **IMPORTANT:** You need to configure your GitHub Pages settings (step 4 above) in order to see your deployed app!

Once you push your changes to the `main` branch:

1. **GitHub Actions** will automatically:
   - Build and test your smart contracts
   - Build your frontend application
   - Deploy to GitHub Pages

2. **Your app will be live at:**
   ```
   https://<YOUR-USERNAME>.github.io/<YOUR-REPO-NAME>/
   ```

3. **Monitor deployment:**
   - Go to your repository's `Actions` tab
   - Watch the build and deployment progress
   - Check the `deploy` job for the live URL

## 🔧 Development

### Local Development
```bash
# Start frontend development server
cd ui
npm install
npm run dev
```

### Smart Contract Development
```bash
# Build contracts
cd move
sui move build

# Run tests
sui move test

# Deploy to testnet
sui client publish
```

## 🎯 Success Criteria

Your project is complete when:
- ✅ All smart contract tests pass
- ✅ All TODO items are implemented
- ✅ Frontend builds without errors
- ✅ App is successfully deployed to GitHub Pages
- ✅ All features work as expected