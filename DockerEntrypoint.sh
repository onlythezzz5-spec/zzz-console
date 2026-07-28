#!/bin/sh

# Start fail2ban. XUI_ENABLE_FAIL2BAN remains a compatibility fallback.
FAIL2BAN_ENABLED="${ZZZ_ENABLE_FAIL2BAN:-${XUI_ENABLE_FAIL2BAN:-false}}"
[ "$FAIL2BAN_ENABLED" = "true" ] && fail2ban-client -x start

# Run zzz
exec /app/zzz
