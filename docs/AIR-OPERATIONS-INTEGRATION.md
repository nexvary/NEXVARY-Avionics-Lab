# Air Operations Integration

NEXVARY Avionics Lab now contains an **Air Operations Integration** layer that can consume normalized awareness data exported by `Aegis-CUAS-Command`.

## Purpose

The integration is designed for:

- synthetic training;
- replay and after-action review;
- airspace-awareness visualization;
- incident context;
- engineering correlation with avionics telemetry and digital-twin state;
- future attachment of additional awareness/readiness modules through the same contract.

It is not an engagement or aircraft-control interface.

## Exchange contract

Schema identifier:

```text
nexvary.air-operations.exchange/v1
```

Accepted modes:

```text
simulation-replay
awareness-only
```

The v1 payload contains:

- source and generation metadata;
- normalized air tracks;
- classification and confidence;
- position, altitude, speed and heading;
- contributing sensor names;
- awareness-level threat context;
- incident summaries;
- aggregate counts.

## Safety gate

The C++ parser rejects exchange documents containing fields whose names indicate active-control surfaces, including actuation, engagement, jamming, spoofing, takeover, weapon or fire-control concepts. This is a schema-level defense in addition to the project safety boundary.

The integration remains read-only from the perspective of Aegis. No reverse command channel is created.

## UI

The **Air Operations** workspace presents:

- track, incident, observation and high-attention counts;
- a training/replay scope;
- normalized track rows;
- incident context;
- the four-layer integration architecture;
- a visible safety-boundary notice.

## Extensibility

A third project can join later by exporting the same v1 contract or a versioned successor. This keeps each repository independently buildable while allowing the command interface to provide one integrated operational picture for training, readiness and engineering analysis.
