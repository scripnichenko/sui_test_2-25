import { useSuiClientQueries } from "@mysten/dapp-kit";
import { Badge, Card, Flex, Grid, Heading, Text } from "@radix-ui/themes";
import { useNetworkVariable } from "../networkConfig";

export default function EventsHistory() {
  const packageId = useNetworkVariable("packageId");

  const eventQueries = useSuiClientQueries({
    queries: [
      {
        method: "queryEvents",
        params: {
          query: {
            MoveEventType: `${packageId}::marketplace::HeroListed`,
          },
          limit: 20,
          order: "descending",
        },
        queryKey: ["queryEvents", packageId, "HeroListed"],
        enabled: !!packageId,
      },
      {
        method: "queryEvents",
        params: {
          query: {
            MoveEventType: `${packageId}::marketplace::HeroBought`,
          },
          limit: 20,
          order: "descending",
        },
        queryKey: ["queryEvents", packageId, "HeroBought"],
        enabled: !!packageId,
      },
      {
        method: "queryEvents",
        params: {
          query: {
            MoveEventType: `${packageId}::arena::ArenaCreated`,
          },
          limit: 20,
          order: "descending",
        },
        queryKey: ["queryEvents", packageId, "ArenaCreated"],
        enabled: !!packageId,
      },
      {
        method: "queryEvents",
        params: {
          query: {
            MoveEventType: `${packageId}::arena::ArenaCompleted`,
          },
          limit: 20,
          order: "descending",
        },
        queryKey: ["queryEvents", packageId, "ArenaCompleted"],
        enabled: !!packageId,
      },
      {
        method: "queryEvents",
        params: {
          query: {
            MoveEventType: `${packageId}::marketplace::AuctionCreated`,
          },
          limit: 20,
          order: "descending",
        },
        queryKey: ["queryEvents", packageId, "AuctionCreated"],
        enabled: !!packageId,
      },
      {
        method: "queryEvents",
        params: {
          query: {
            MoveEventType: `${packageId}::marketplace::BidPlaced`,
          },
          limit: 20,
          order: "descending",
        },
        queryKey: ["queryEvents", packageId, "BidPlaced"],
        enabled: !!packageId,
      },
      {
        method: "queryEvents",
        params: {
          query: {
            MoveEventType: `${packageId}::marketplace::AuctionEnded`,
          },
          limit: 20,
          order: "descending",
        },
        queryKey: ["queryEvents", packageId, "AuctionEnded"],
        enabled: !!packageId,
      },
    ],
  });

  const [
    { data: listedEvents, isPending: isListedPending },
    { data: boughtEvents, isPending: isBoughtPending },
    { data: battleCreatedEvents, isPending: isBattleCreatedPending },
    { data: battleCompletedEvents, isPending: isBattleCompletedPending },
    { data: auctionCreatedEvents, isPending: isAuctionCreatedPending },
    { data: bidPlacedEvents, isPending: isBidPlacedPending },
    { data: auctionEndedEvents, isPending: isAuctionEndedPending },
  ] = eventQueries;

  const formatTimestamp = (timestamp: string) => {
    return new Date(Number(timestamp)).toLocaleString();
  };

  const formatAddress = (address: string) => {
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  };

  const formatPrice = (price: string) => {
    return (Number(price) / 1_000_000_000).toFixed(2);
  };

  if (
    isListedPending ||
    isBoughtPending ||
    isBattleCreatedPending ||
    isBattleCompletedPending ||
    isAuctionCreatedPending ||
    isBidPlacedPending ||
    isAuctionEndedPending
  ) {
    return (
      <Card>
        <Text>Loading events history...</Text>
      </Card>
    );
  }

  const allEvents = [
    ...(listedEvents?.data || []).map((event) => ({
      ...event,
      type: "listed" as const,
    })),
    ...(boughtEvents?.data || []).map((event) => ({
      ...event,
      type: "bought" as const,
    })),
    ...(battleCreatedEvents?.data || []).map((event) => ({
      ...event,
      type: "battle_created" as const,
    })),
    ...(battleCompletedEvents?.data || []).map((event) => ({
      ...event,
      type: "battle_completed" as const,
    })),
    ...(auctionCreatedEvents?.data || []).map((event) => ({
      ...event,
      type: "auction_created" as const,
    })),
    ...(bidPlacedEvents?.data || []).map((event) => ({
      ...event,
      type: "bid_placed" as const,
    })),
    ...(auctionEndedEvents?.data || []).map((event) => ({
      ...event,
      type: "auction_ended" as const,
    })),
  ].sort((a, b) => Number(b.timestampMs) - Number(a.timestampMs));

  return (
    <Flex direction="column" gap="4">
      <Heading size="6">Recent Events ({allEvents.length})</Heading>

      {allEvents.length === 0 ? (
        <Card>
          <Text>No events found</Text>
        </Card>
      ) : (
        <Grid columns="1" gap="3">
          {allEvents.map((event, index) => {
            const eventData = event.parsedJson as any;

            return (
              <Card
                key={`${event.id.txDigest}-${index}`}
                style={{ padding: "16px" }}
              >
                <Flex direction="column" gap="2">
                  <Flex align="center" gap="3">
                    <Badge
                      color={
                        event.type === "listed"
                          ? "blue"
                          : event.type === "bought"
                            ? "green"
                            : event.type === "battle_created"
                              ? "orange"
                              : event.type === "battle_completed"
                                ? "red"
                                : event.type === "auction_created"
                                  ? "purple"
                                  : event.type === "bid_placed"
                                    ? "yellow"
                                    : "indigo"
                      }
                      size="2"
                    >
                      {event.type === "listed"
                        ? "Hero Listed"
                        : event.type === "bought"
                          ? "Hero Bought"
                          : event.type === "battle_created"
                            ? "Arena Created"
                            : event.type === "battle_completed"
                              ? "Battle Completed"
                              : event.type === "auction_created"
                                ? "Auction Created"
                                : event.type === "bid_placed"
                                  ? "Bid Placed"
                                  : "Auction Ended"}
                    </Badge>
                    <Text size="3" color="gray">
                      {formatTimestamp(event.timestampMs!)}
                    </Text>
                  </Flex>

                  <Flex align="center" gap="4" wrap="wrap">
                    {(event.type === "listed" || event.type === "bought") && (
                      <>
                        <Text size="3">
                          <strong>Price:</strong> {formatPrice(eventData.price)}{" "}
                          SUI
                        </Text>

                        {event.type === "listed" ? (
                          <Text size="3">
                            <strong>Seller:</strong>{" "}
                            {formatAddress(eventData.seller)}
                          </Text>
                        ) : (
                          <Flex gap="4">
                            <Text size="3">
                              <strong>Buyer:</strong>{" "}
                              {formatAddress(eventData.buyer)}
                            </Text>
                            <Text size="3">
                              <strong>Seller:</strong>{" "}
                              {formatAddress(eventData.seller)}
                            </Text>
                          </Flex>
                        )}

                        <Text
                          size="3"
                          color="gray"
                          style={{ fontFamily: "monospace" }}
                        >
                          ID: {eventData.id?.slice(0, 8) || 'N/A'}...
                        </Text>
                      </>
                    )}

                    {event.type === "battle_created" && (
                      <>
                        <Text size="3">
                          <strong>⚔️ Battle Arena Created</strong>
                        </Text>
                        <Text
                          size="3"
                          color="gray"
                          style={{ fontFamily: "monospace" }}
                        >
                          ID: {eventData.id?.slice(0, 8) || 'N/A'}...
                        </Text>
                      </>
                    )}

                    {event.type === "battle_completed" && (
                      <>
                        <Text size="3">
                          <strong>🏆 Winner:</strong> ...
                          {eventData.winner?.slice(-8) || 'N/A'}
                        </Text>
                        <Text size="3">
                          <strong>💀 Loser:</strong> ...
                          {eventData.loser?.slice(-8) || 'N/A'}
                        </Text>
                      </>
                    )}

                    {event.type === "auction_created" && (
                      <>
                        <Text size="3">
                          <strong>Starting Price:</strong> {formatPrice(eventData.starting_price)} SUI
                        </Text>
                        <Text size="3">
                          <strong>Seller:</strong> {formatAddress(eventData.seller)}
                        </Text>
                        <Text size="3">
                          <strong>End Time:</strong> {formatTimestamp(eventData.end_time)}
                        </Text>
                        <Text
                          size="3"
                          color="gray"
                          style={{ fontFamily: "monospace" }}
                        >
                          Auction ID: {eventData.auction_id?.slice(0, 8) || 'N/A'}...
                        </Text>
                      </>
                    )}

                    {event.type === "bid_placed" && (
                      <>
                        <Text size="3">
                          <strong>Bid Amount:</strong> {formatPrice(eventData.amount)} SUI
                        </Text>
                        <Text size="3">
                          <strong>Bidder:</strong> {formatAddress(eventData.bidder)}
                        </Text>
                        <Text
                          size="3"
                          color="gray"
                          style={{ fontFamily: "monospace" }}
                        >
                          Auction ID: {eventData.auction_id?.slice(0, 8) || 'N/A'}...
                        </Text>
                      </>
                    )}

                    {event.type === "auction_ended" && (
                      <>
                        <Text size="3">
                          <strong>Final Price:</strong> {formatPrice(eventData.final_price)} SUI
                        </Text>
                        {eventData.winner && eventData.winner !== '0x0000000000000000000000000000000000000000000000000000000000000000' ? (
                          <Text size="3">
                            <strong>Winner:</strong> {formatAddress(eventData.winner)}
                          </Text>
                        ) : (
                          <Text size="3">
                            <strong>Result:</strong> No bids placed
                          </Text>
                        )}
                        <Text size="3">
                          <strong>Seller:</strong> {formatAddress(eventData.seller)}
                        </Text>
                        <Text
                          size="3"
                          color="gray"
                          style={{ fontFamily: "monospace" }}
                        >
                          Auction ID: {eventData.auction_id?.slice(0, 8) || 'N/A'}...
                        </Text>
                      </>
                    )}
                  </Flex>
                </Flex>
              </Card>
            );
          })}
        </Grid>
      )}
    </Flex>
  );
}
