module nft::nft {

    use sui::event;
    use sui::url::{Self, Url};
    use std::string::{Self, String};

    public struct NFT has key, store {
        id: UID,
        name: String,
        description: String,
        url: Url,
    }

    // event
    public struct NFTMinted has copy, drop {
        object_id: ID,
        creator: address,
        name: String,
    }

    /// Mint new NFT
    public entry fun mint(name: vector<u8>, description: vector<u8>, url: vector<u8>, ctx: &mut TxContext) {
        let nft = NFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url)
        };

        // mint and send the NFT to the caller
        let sender = tx_context::sender(ctx);

        // emit event
        event::emit(NFTMinted {
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name
        });

        // transfer nft
        transfer::public_transfer(nft, sender);
    }

    /// Transfer NFT to another recipient
    public entry fun transfer(nft: NFT, recipient: address) {
        transfer::public_transfer(nft, recipient);
    }

    /// Burn NFT
    public entry fun burn(nft: NFT) {
        let NFT { id, name: _, description: _, url: _ } = nft;
        id.delete();
    }

    /// Update the `description` of `nft` to `new_description`
    public fun update_description(nft: &mut NFT, new_description: vector<u8>) {
        nft.description = string::utf8(new_description);
    }

    public fun name(nft: &NFT): &String {
        &nft.name
    }

    public fun description(nft: &NFT): &String {
        &nft.description
    }

    public fun url(nft: &NFT): &Url {
        &nft.url
    }

}