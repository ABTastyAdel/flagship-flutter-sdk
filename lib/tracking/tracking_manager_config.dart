const int DEFAULT_BATCH_LENGTH = 20; // Exctract 20 hits from the loop

const int DEFAULT_TIME_INTERVAL =
    20; // On each 10 seconds will launch the batch from the queue

enum BatchCachingStrategy {
  BATCH_CONTINUOUS_CACHING, // Cache on continous when hit occurs

  BATCH_PERIODIC_CACHING, // Cache when batch is launched

  NO_BATCHING_CONTINUOUS_CACHING_STRATEGY // Hidden option with no caching and no batching
}

class TrackingManagerConfig {
  // Define the time intervals the SDK will use to send tracking batches.
  final int batchIntervals;
  // Define the maximum number of tracking hit that each batch can contain.
  final int poolMaxSize;

  // indicate the strategy to adopt for the cache manager
  final BatchCachingStrategy batchStrategy;

  TrackingManagerConfig(
      {this.batchIntervals = DEFAULT_TIME_INTERVAL,
      this.poolMaxSize = DEFAULT_BATCH_LENGTH,
      this.batchStrategy = BatchCachingStrategy.BATCH_CONTINUOUS_CACHING});
}