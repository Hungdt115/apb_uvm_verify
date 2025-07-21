import re

def parse_uvm_log(file_path):
    errors = []
    warnings = []
    infos = []

    # Updated regex to capture file_path and line_num explicitly
    # Example: UVM_ERROR /home/hungdt/01_Verilog/02_apb_uvm_verify/env/apb_scoreboard.sv(48) @ 40000: uvm_test_top.env.scb [APB_SCOREBOARD] ------ :: READ DATA MisMatch :: ------
    log_pattern = re.compile(
        r'UVM_(?P<severity>ERROR|WARNING|INFO)\s+'
        r'(?P<file_path>.*?)\((?P<line_num>\d+)\)\s+@\s+'
        r'(?P<time>\d+):\s+'
        r'(?P<component>.*?)\s+'
        r'\[(?P<id>.*?)\]\s+'
        r'(?P<message>.*)'
    )

    with open(file_path, 'r') as file:
        for line in file:
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
                    errors.append(entry)
                elif severity == 'WARNING':
                    warnings.append(entry)
                elif severity == 'INFO':
                    infos.append(entry)

    return errors, warnings, infos


def print_summary(errors, warnings, infos):
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
    errors, warnings, infos = parse_uvm_log(log_file)
    print_summary(errors, warnings, infos)