import SwiftUI

struct SellerDetailView: View {
    let seller: User

    var body: some View {
        VStack(spacing: 20) {
            Text("Seller Information")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
                .foregroundColor(.primary)

            VStack(alignment: .leading, spacing: 10) {
                Text("Name: \(seller.username)")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Email: \(seller.email)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Address: \(seller.address)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                HStack {
                    if let fb = seller.facebookLink {
                        SocialMediaLink(icon: "facebook", url: fb)
                    }
                    if let ld = seller.linkedinLink {
                        SocialMediaLink(icon: "linkedin", url: ld)
                    }
                    if let tw = seller.twitterLink {
                        SocialMediaLink(icon: "twitter", url: tw)
                    }
                    if let ig = seller.instagramLink {
                        SocialMediaLink(icon: "instagram", url: ig)
                    }
                }
                .padding(.top, 5)
                
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
            
            Spacer()
        }
        .padding()
    }
}

struct SocialMediaLink: View {
    let icon: String
    let url: String

    var body: some View {
        HStack {
            Image(systemName: "\(icon).circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.blue)
            Text(url)
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .padding(.horizontal, 5)
        .onTapGesture {
            if let link = URL(string: url) {
                UIApplication.shared.open(link)
            }
        }
    }
}

