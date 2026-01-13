
import re
import sys
import os

def parse_log(filepath):
    # Regex to capture timestamp at start of line: +1234567890.123456789
    ts_pattern = re.compile(r"^\++(\d+\.\d+)\s+(.*)$")
    
    lines_data = []
    
    try:
        with open(filepath, 'r') as f:
            for line in f:
                match = ts_pattern.match(line)
                if match:
                    ts_str, command = match.groups()
                    ts = float(ts_str)
                    lines_data.append({'ts': ts, 'command': command.strip(), 'line': line.strip()})
    except FileNotFoundError:
        print(f"Error: File {filepath} not found.")
        return

    if not lines_data:
        print("No valid data found in log. Ensure PS4='+${EPOCHREALTIME} ' is set before running bash -x.")
        return

    # Calculate durations
    delays = []
    for i in range(len(lines_data) - 1):
        duration = lines_data[i+1]['ts'] - lines_data[i]['ts']
        delays.append({
            'duration': duration,
            'command': lines_data[i]['command'],
            'start_ts': lines_data[i]['ts']
        })

    # Sort by duration
    delays.sort(key=lambda x: x['duration'], reverse=True)

    print(f"Total entries: {len(delays)}")
    print(f"Total duration: {lines_data[-1]['ts'] - lines_data[0]['ts']:.4f}s")
    print("\nTop 20 Slowest Commands:")
    for i, d in enumerate(delays[:20]):
        print(f"{i+1}. {d['duration']:.4f}s: {d['command']}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 analyze_bash_profile.py <logfile>")
        sys.exit(1)
    
    parse_log(sys.argv[1])
