import json
import urllib.request

def get_location(ip: str) -> str | None:
    if not ip or ip.startswith(("10.", "172.", "192.168.", "127.")):
        return "localhost"
    try:
        url = f"http://ip-api.com/json/{ip}?fields=status,city,country"
        with urllib.request.urlopen(url, timeout=3) as r:
            data = json.loads(r.read())
        if data.get("status") == "success":
            parts = [data.get("city", ""), data.get("country", "")]
            return ", ".join(p for p in parts if p)
    except Exception:
        pass
    return None
