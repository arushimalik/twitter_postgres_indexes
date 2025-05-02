/*
 * Calculates the hashtags that are commonly used with the hashtag #coronavirus
 */

SELECT
  '#' || hashtags.tag AS tag,       -- Add '#' and show the hashtag
  COUNT(*)            AS count      -- Count how often it appears with #coronavirus
FROM (
  SELECT DISTINCT
    tweet.data->>'id'         AS tweet_id,  -- Unique tweet ID
    hashtag_elem->>'text'     AS tag        -- Text of the hashtag
  FROM tweets_jsonb AS tweet

  -- Combine hashtags from normal and extended tweet fields
  CROSS JOIN LATERAL (
    VALUES (
      COALESCE(tweet.data->'entities'->'hashtags', '[]'::jsonb) ||
      COALESCE(tweet.data->'extended_tweet'->'entities'->'hashtags', '[]'::jsonb)
    )
  ) AS combined(hashtags_array)

  -- Unpack each hashtag from the array
  CROSS JOIN LATERAL
    jsonb_array_elements(combined.hashtags_array) AS hashtag_elem

  -- Only keep tweets that contain the hashtag 'coronavirus'
  WHERE combined.hashtags_array @> '[{"text":"coronavirus"}]'::jsonb
) AS hashtags
GROUP BY hashtags.tag
ORDER BY count DESC, hashtags.tag
LIMIT 1000;

