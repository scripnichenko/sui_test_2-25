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

## Extra feature

### 🏆 Auction System

I've implemented a comprehensive **Auction System** as an extra feature to complement the existing fixed-price marketplace. This feature allows users to create time-limited auctions for their Hero NFTs where other users can place competitive bids.

#### Key Features:

1. **Auction Creation**
   - Users can create auctions for their Hero NFTs
   - Set a starting price and auction duration
   - Automatic end time calculation

2. **Bidding Mechanism**
   - Users can place bids on active auctions
   - Bid validation ensures higher bids than current highest
   - Minimum bid must be at least the starting price
   - Real-time bid tracking and updates

3. **Auction Management**
   - Automatic auction ending when time expires
   - Winner determination based on highest bid
   - NFT transfer to winning bidder
   - Return to seller if no bids placed

4. **Admin Controls**
   - Admin can cancel auctions if needed
   - Emergency auction termination capability

5. **Event System**
   - `AuctionCreated` - When a new auction is created
   - `BidPlaced` - When someone places a bid
   - `AuctionEnded` - When an auction concludes

6. **Getter Functions**
   - Access auction details like current bid, bidder, end time
   - Check if auction has bids
   - Get seller and starting price information

#### Technical Implementation:

- **Structs**: `Auction`, `Bid` for data management
- **Events**: Comprehensive event emission for frontend integration
- **Error Handling**: Custom error codes for different failure scenarios
- **Time Management**: Epoch timestamp-based auction duration
- **Security**: Proper validation and access controls

This auction system enhances the marketplace by providing an alternative trading mechanism that can potentially achieve higher prices through competitive bidding, making the Hero NFT marketplace more dynamic and engaging for users.