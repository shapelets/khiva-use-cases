#!/usr/local/bin/python3

import matplotlib

matplotlib.use("TkAgg")
from tkinter import *
import khiva as kv
from scipy.interpolate import interp1d
import numpy as np
import scipy as sp
import matplotlib.pyplot as plt
import matplotlib.backends.tkagg as tkagg
from matplotlib.backends.backend_agg import FigureCanvasAgg
import tkinter as tk
from tkinter.filedialog import askopenfilename


class Paint(object):
    DEFAULT_PEN_SIZE = 5.0
    DEFAULT_COLOR = 'black'

    def __init__(self):
        self.root = Tk()
        self.root.title("Khiva's Pattern Discovery")
        self.points_entry = Entry(self.root)
        self.data = None
        tk.Button(self.root, text='Connect with data source', command=self.import_csv_data).grid(row=1, column=0)
        self.points_entry.grid(row=1, column=4, pady=(20, 0))
        self.points = Label(self.root, text="Points")
        self.points.grid(row=1, column=3, padx=(1000, 0), pady=(20, 0))
        self.maximum = Label(self.root, text="Max")
        self.maximum.grid(row=2, column=3, padx=(1000, 0))
        self.minimum = Label(self.root, text="Min")
        self.minimum.grid(row=3, column=3, padx=(1000, 0))
        self.max = Entry(self.root)
        self.photo = None
        self.max.grid(row=2, column=4)
        self.min = Entry(self.root)
        self.old_x = None
        self.old_y = None

        self.min.grid(row=3, column=4, )
        self.find_button = Button(self.root, text='Find', command=self.use_find)
        self.find_button.grid(row=1, column=3, padx=(0, 5))
        self.clear_button = Button(self.root, text='Clear', command=self.use_clear)
        self.clear_button.grid(row=2, column=3)
        self.choose_size_button = Scale(self.root, from_=1, to=10, orient=HORIZONTAL)
        gif1 = PhotoImage(file='./ShapeletsLogo.gif')
        self.c = Canvas(self.root, bg='white', width=1700, height=1200)
        self.c.pack(expand=YES, fill=BOTH)
        self.c.create_image(50, 10, image=gif1, anchor=NW)
        self.c.bind('<Configure>', self.create_grid)
        self.line_width = 1
        self.c.grid(row=4, columnspan=5)
        self.subsequence = []
        self.subsequence_x = []
        self.c.bind('<B1-Motion>', self.paint)
        self.root.mainloop()

    def import_csv_data(self):
        csv_file_path = askopenfilename()
        self.data = np.genfromtxt(csv_file_path, delimiter=',')
        self.kv_time_series = kv.max_min_norm(kv.Array(self.data), int(200), int(-200))


    def use_find(self):
        plt.close('all')
        new_length = self.points_entry.get()

        y = kv.max_min_norm(kv.Array(self.subsequence), int(self.max.get()), int(self.min.get())).to_numpy()
        x = np.array(self.subsequence_x)
        y = np.array(y)

        new_x = np.linspace(x.min(), x.max(), new_length)
        new_y = sp.interpolate.interp1d(x, y)(new_x)
        y = new_y
        b = kv.Array(y, khiva_type=kv.dtype.f32)
        distance, profile = kv.stomp(self.kv_time_series, b, len(y))
        distance_motif, index_motif, index_subsequence_motif = kv.find_best_n_motifs(distance, profile, 1)
        index_motif = index_motif.to_numpy()
        a = self.kv_time_series.to_numpy()
        window = int(2 * len(y))
        fig = plt.figure(1)
        plt.plot(range(index_motif, index_motif + (len(y))), y, label="Selected pattern", color="blue")

        if index_motif == 0:
            plt.plot(range(index_motif, index_motif + window), a[index_motif:index_motif + window],
                     label="Time series", color="orange")
            plt.plot(range(index_motif, (index_motif + len(y))),
                     a[index_motif: (index_motif + len(y))], label="Discovered motif", color="red")
            plt.xticks(np.arange(min(range(index_motif, index_motif + window)), max(range(index_motif, index_motif +
                                                                                          window)), 100.0))
        else:

            plt.plot(range(index_motif - window, index_motif + window), a[index_motif - window:index_motif + window],
                     label="Time series", color="orange")
            plt.plot(range(index_motif, (index_motif + len(y))),
                     a[index_motif: (index_motif + len(y))], label="Discovered motif", color="red")
            plt.xticks(np.arange(min(range(index_motif - window, index_motif + window)), max(range(index_motif - window,
                                                                                                   index_motif + window)),
                                 100.0))

        plt.legend()
        plt.title("Motif discovery")
        plt.tight_layout()
        fig_photo = self.draw_figure(self.c, fig, loc=(1010, 250))
        self.photo = fig_photo

    def draw_figure(self, canvas, figure, loc=(0, 0)):
        figure_canvas_agg = FigureCanvasAgg(figure)
        figure_canvas_agg.draw()
        figure_x, figure_y, figure_w, figure_h = figure.bbox.bounds
        figure_w, figure_h = int(figure_w), int(figure_h)
        photo = PhotoImage(master=canvas, width=figure_w, height=figure_h)
        canvas.create_image(loc[0] + figure_w / 2, loc[1] + figure_h / 2, image=photo)
        tkagg.blit(photo, figure_canvas_agg.get_renderer()._renderer, colormode=2)

        return photo

    def use_clear(self):
        self.subsequence = []
        self.subsequence_x = []
        self.old_y = None
        self.old_x = None
        self.c.delete("sequence")

    def paint(self, event):
        self.line_width = self.choose_size_button.get()

        w = self.c.winfo_width()
        h = self.c.winfo_height()
        paint_color = self.DEFAULT_COLOR
        if self.old_x and self.old_y and (w - 705) > event.x > 200 and 300 < event.y < h - 505 \
                and (w - 705) > self.old_x > 200 and 300 < self.old_y < h - 505:
            self.c.create_line(self.old_x, self.old_y, event.x, event.y,
                               width=self.line_width, fill=paint_color,
                               capstyle=ROUND, smooth=TRUE, splinesteps=1, tag='sequence')

        self.old_x = event.x
        self.old_y = event.y

        self.subsequence = list(self.subsequence)
        self.subsequence_x = list(self.subsequence_x)
        if self.old_x and self.old_y and (w - 705) > event.x > 200 and 300 < event.y < h - 505 \
                and (w - 705) > self.old_x > 200 and 300 < self.old_y < h - 505:
            self.subsequence.append(event.y * -1)
            self.subsequence_x.append(event.x)

    def create_grid(self, event):
        c = self.c
        w = c.winfo_width()
        h = c.winfo_height()
        c.delete('grid_line')

        # Vertical lines
        for i in range(0, w - 600, 200):
            c.create_line([(i, 300), (i, h - 505)], tag='grid_line', fill="gray")

        # Horizontal lines
        for i in range(300, h - 200, 200):
            c.create_line([(200, i), (w - 705, i)], tag='grid_line', fill="gray")


if __name__ == '__main__':
    Paint()
