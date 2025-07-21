import re

def parse_uvm_log(file_path):
    errors = []
    warnings = []
    infos = []
    line_count = 0

    log_pattern = re.compile(
        r'UVM_(?P<severity>ERROR|WARNING|INFO)\s+'
        r'(?P<file_path>.*?)\((?P<line_num>\d+)\)\s+@\s+'
        r'(?P<time>\d+):\s+'
        r'(?P<component>.*?)\s+'
        r'\[(?P<id>.*?)\]\s+'
        r'(?P<message>.*)'
    )

    with open(file_path, 'r') as file:
        lines = file.readlines()
        total_lines = len(lines)

        i = 0
        while i < total_lines:
            line = lines[i]
            line_count += 1
            match = log_pattern.match(line)
            if match:
                entry = {
                    'file_path': match.group('file_path'),
                    'line': int(match.group('line_num')),
                    'time': int(match.group('time')),
                    'component': match.group('component'),
                    'id': match.group('id'),
                    'message': match.group('message')
                }
                severity = match.group('severity')

                if severity == 'ERROR':
                    extra_lines = []
                    for j in range(1, 3):
                        if i + j < total_lines:
                            extra_lines.append(lines[i + j].rstrip())
                            line_count += 1
                    if extra_lines:
                        entry['message'] += '\n' + '\n'.join(extra_lines)
                    errors.append(entry)
                elif severity == 'WARNING':
                    warnings.append(entry)
                elif severity == 'INFO':
                    infos.append(entry)
            i += 1

    return errors, warnings, infos, line_count


def print_summary(errors, warnings, infos, line_count):
    print(f"\nTotal lines read: {line_count}")
    print(f'\n🔴 Errors: {len(errors)}')
    for err in errors:
        print(f"[{err['time']}] {err['component']} ({err['file_path']}:{err['line']}) - {err['id']} - {err['message']}")

    print(f'\n🟡 Warnings: {len(warnings)}')
    for warn in warnings:
        print(f"[{warn['time']}] {warn['component']} ({warn['file_path']}:{warn['line']}) - {warn['id']} - {warn['message']}")

    print(f'\n🔵 Infos: {len(infos)} (showing first 5)')
    for info in infos[:5]:
        print(f"[{info['time']}] {info['component']} ({info['file_path']}:{info['line']}) - {info['id']} - {info['message']}")


if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python uvm_log_parser.py <log_file>")
        sys.exit(1)

    log_file = sys.argv[1]
    errors, warnings, infos, line_count = parse_uvm_log(log_file)
    print_summary(errors, warnings, infos, line_count)
