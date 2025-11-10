function plotFilterResponse(ax, b, a, fs)
% 在 ax 上绘制 |H(f)| 的 dB 响应
    [H, f] = freqz(b, a, 2048, fs);
    cla(ax);
    plot(ax, f, 20*log10(abs(H)+eps), 'LineWidth', 1.5);
    % grid(ax, 'on');
    xlim(ax, [0 fs/2]);
    ylim(ax, [-100 5]);
    % xlabel(ax, 'Frequency (Hz)');
    % ylabel(ax, 'Magnitude (dB)');
    % title(ax, titleStr);
end