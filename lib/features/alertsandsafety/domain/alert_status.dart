enum AlertStatus {
  raised,
  dispatched,
  dispatchFailed,
  acknowledged,
  resolved;

  static AlertStatus fromName(String name) {
    return switch (name) {
      'DISPATCHED' => AlertStatus.dispatched,
      'DISPATCH_FAILED' => AlertStatus.dispatchFailed,
      'ACKNOWLEDGED' => AlertStatus.acknowledged,
      'RESOLVED' => AlertStatus.resolved,
      _ => AlertStatus.raised,
    };
  }

  bool get isAcknowledged => this == AlertStatus.acknowledged;

  bool get isResolved => this == AlertStatus.resolved;

  bool get isPending => !isAcknowledged && !isResolved;

  bool get isOpen => !isResolved;
}
