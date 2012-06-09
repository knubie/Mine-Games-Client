// Generated by CoffeeScript 1.3.2
var onBodyLoad, onDeviceReady, server_url,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

server_url = "http://mine-games.herokuapp.com";

onBodyLoad = function() {
  return document.addEventListener("deviceready", onDeviceReady, false);
};

onDeviceReady = function() {
  return $(function() {
    var CardDetailView, CardListView, Deck, Decks, LobbyView, Match, MatchListView, MatchView, Matches, ShopListView, ShopView, actions, cards, changePage, current, decks, facebook_auth, gsub, matches;
    gsub = function(source, pattern, replacement) {
      var match, result;
      if (!((pattern != null) && (replacement != null))) {
        return source;
      }
      result = '';
      while (source.length > 0) {
        if ((match = source.match(pattern))) {
          result += source.slice(0, match.index);
          result += replacement;
          source = source.slice(match.index + match[0].length);
        } else {
          result += source;
          source = '';
        }
      }
      return result;
    };
    Array.prototype.minus = function(v) {
      var results, x, _i, _len;
      results = [];
      for (_i = 0, _len = this.length; _i < _len; _i++) {
        x = this[_i];
        if (x !== v) {
          results.push(x);
        } else {
          v = '';
        }
      }
      return results;
    };
    Array.prototype.popper = function(e) {
      var popper, _ref;
      popper = this.slice(e, e + 1 || 9e9);
      [].splice.apply(this, [e, e - e + 1].concat(_ref = [])), _ref;
      return popper;
    };
    changePage = function(page, options) {
      var $curr, $page;
      $curr = $('.active');
      $page = $(page);
      if (options.reverse === true) {
        $curr.addClass('reverse');
        $page.addClass('reverse');
      }
      if (options.transition === 'none') {
        console.log('no transition');
        $curr.removeClass('active');
        return $page.addClass('active');
      } else {
        $curr.addClass('slide out');
        $page.addClass('slide in active');
        return setTimeout(function() {
          console.log('settimeout');
          $curr.removeClass('slide out active reverse');
          return $page.removeClass('slide in reverse');
        }, 350);
      }
    };
    cards = {
      stone_pickaxe: {
        name: 'stone pickaxe',
        type: 'action',
        cost: 3,
        use: function() {
          return actions.mine({
            number: 1,
            callback: function(new_card) {
              var log, log_msg;
              console.log('calling callback');
              log_msg = "<span class='name'>" + current.user.username + "</span> used an <span class='item action'>Stone Pickaxe</span> and got a <span class='money'>" + new_card + "</span>";
              if (typeof current.match.get('log') !== 'Array') {
                log = [];
              } else {
                log = current.match.get('log');
              }
              log.push(log_msg);
              current.match.set('log', log);
              return console.log(log_msg);
            }
          });
        }
      },
      iron_pickaxe: {
        name: 'iron pickaxe',
        type: 'action',
        cost: 5,
        use: function() {
          return actions.mine({
            number: 2,
            callback: function(new_card) {
              var log, log_msg;
              console.log('calling callback');
              log_msg = "<span class='name'>" + current.user.username + "</span> used an <span class='item action'>Iron Pickaxe</span> and got a <span class='money'>" + new_card + "</span>";
              if (typeof current.match.get('log') !== 'Array') {
                log = [];
              } else {
                log = current.match.get('log');
              }
              log.push(log_msg);
              current.match.set('log', log);
              return console.log(log_msg);
            }
          });
        }
      },
      diamond_pickaxe: {
        name: 'diamond pickaxe',
        type: 'action',
        cost: 8,
        use: function() {
          return actions.mine({
            number: 3,
            callback: function(new_card) {
              var log, log_msg;
              console.log('calling callback');
              log_msg = "<span class='name'>" + current.user.username + "</span> used an <span class='item action'>Diamond Pickaxe</span> and got a <span class='money'>" + new_card + "</span>";
              if (typeof current.match.get('log') !== 'Array') {
                log = [];
              } else {
                log = current.match.get('log');
              }
              log.push(log_msg);
              current.match.set('log', log);
              return console.log(log_msg);
            }
          });
        }
      },
      copper: {
        name: 'copper',
        type: 'money',
        value: 1,
        use: function() {
          console.log('copper used');
          return actions.discard({
            number: 2
          });
        }
      },
      silver: {
        name: 'silver',
        type: 'money',
        value: 2,
        use: function() {
          console.log('copper used');
          return actions.discard({
            number: 2
          });
        }
      },
      gold: {
        name: 'gold',
        type: 'money',
        value: 3,
        use: function() {
          console.log('copper used');
          return actions.discard({
            number: 2
          });
        }
      },
      diamond: {
        name: 'diamond',
        type: 'money',
        value: 5,
        use: function() {
          console.log('copper used');
          return actions.discard({
            number: 2
          });
        }
      },
      coal: {
        name: 'coal',
        type: 'coal',
        value: 0,
        use: function() {
          console.log('copper used');
          return actions.discard({
            number: 2
          });
        }
      },
      tnt: {
        name: 'tnt',
        type: 'action',
        cost: 6,
        use: function() {}
      },
      minecart: {
        name: 'minecart',
        type: 'action',
        cost: 5,
        use: function() {
          current.deck.set('actions', current.deck.get('actions') + 1);
          return actions.draw({
            number: 1,
            callback: function(new_card) {
              var log, log_msg;
              console.log('calling callback');
              log_msg = "<span class='name'>" + current.user.username + "</span> used a <span class='item action'>Minecart</span> and got a <span class='money'>" + new_card + "</span>";
              if (typeof current.match.get('log') !== 'Array') {
                log = [];
              } else {
                log = current.match.get('log');
              }
              log.push(log_msg);
              current.match.set('log', log);
              return console.log(log_msg);
            }
          });
        }
      },
      mule: {
        name: 'mule',
        type: 'action',
        cost: 5,
        use: function() {
          return actions.draw({
            number: 3,
            callback: function(new_card) {
              var log, log_msg;
              console.log('calling callback');
              log_msg = "<span class='name'>" + current.user.username + "</span> used a <span class='item action'>Minecart</span> and got a <span class='money'>" + new_card + "</span>";
              if (typeof current.match.get('log') !== 'Array') {
                log = [];
              } else {
                log = current.match.get('log');
              }
              log.push(log_msg);
              current.match.set('log', log);
              return console.log(log_msg);
            }
          });
        }
      },
      headlamp: {
        name: 'headlamp',
        type: 'action',
        cost: 4
      },
      gopher: {
        name: 'gopher',
        type: 'action',
        cost: 6
      },
      magnet: {
        name: 'magnet',
        type: 'action',
        cost: 6
      },
      alchemy: {
        name: 'alchemy',
        type: 'action',
        cost: 5
      }
    };
    actions = {
      mine: function(options) {
        var h, i, m, nc, view, _i, _ref, _ref1, _results;
        console.log('mine');
        _results = [];
        for (i = _i = 1, _ref = options.number; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
          console.log('iterating..');
          m = current.match.get('mine');
          h = current.deck.get('hand');
          nc = m[0];
          [].splice.apply(m, [0, 1].concat(_ref1 = [])), _ref1;
          h.push(nc);
          current.match.set('mine', m);
          current.deck.set('mine', h);
          console.log("new card: " + nc);
          console.log(current.deck.get('hand'));
          view = new CardListView(cards[gsub(nc, ' ', '_')]);
          current.hand.push(view);
          _results.push(options.callback(nc));
        }
        return _results;
      },
      draw: function(options) {
        var c, h, i, nc, view, _i, _ref, _ref1, _results;
        console.log('draw from your deck');
        _results = [];
        for (i = _i = 1, _ref = options.number; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
          console.log('iterating..');
          c = current.deck.get('cards');
          h = current.deck.get('hand');
          nc = c[0];
          [].splice.apply(c, [0, 1].concat(_ref1 = [])), _ref1;
          h.push(nc);
          current.deck.set({
            cards: c
          });
          current.deck.set({
            hand: h
          });
          console.log("new card: " + nc);
          view = new CardListView(cards[gsub(nc, ' ', '_')]);
          current.hand.push(view);
          _results.push(options.callback(nc));
        }
        return _results;
      },
      discard: function(options, cb) {
        $('.discard').show();
        console.log(options.number);
        return current.deck.set({
          amount_to_discard: options.number,
          amount_discarded: 0,
          discard_type: options.type
        });
      },
      trash: function(i, type, cb) {}
    };
    current = {
      lobby: 0,
      match: 0,
      deck: 0,
      hand: [],
      turn: false,
      user: 0,
      to_spend: 0,
      before_turn: function() {}
    };
    Match = (function(_super) {

      __extends(Match, _super);

      function Match() {
        return Match.__super__.constructor.apply(this, arguments);
      }

      Match.prototype.initialize = function() {
        var _this = this;
        console.log(this.url());
        return this.on('change', function() {
          console.log('saving match');
          return _this.save();
        });
      };

      return Match;

    })(Backbone.Model);
    Matches = (function(_super) {

      __extends(Matches, _super);

      function Matches() {
        return Matches.__super__.constructor.apply(this, arguments);
      }

      Matches.prototype.initialize = function() {
        var _this = this;
        this.fetch();
        return this.on('reset', function() {
          return console.log(_this);
        });
      };

      Matches.prototype.model = Match;

      Matches.prototype.url = "" + server_url + "/matches";

      return Matches;

    })(Backbone.Collection);
    Deck = (function(_super) {

      __extends(Deck, _super);

      function Deck() {
        return Deck.__super__.constructor.apply(this, arguments);
      }

      Deck.prototype.initialize = function() {
        var _this = this;
        return this.on('change', function() {
          console.log('saving deck');
          return _this.save();
        });
      };

      Deck.prototype.amount_to_discard = 0;

      Deck.prototype.amount_discarded = 0;

      Deck.prototype.type = 0;

      Deck.prototype.to_spend = function() {
        var card, to_spend, _fn, _i, _len, _ref;
        to_spend = 0;
        console.log('to spend');
        _ref = this.get('hand');
        _fn = function(card) {
          if (cards[gsub(card, ' ', '_')].type === 'money') {
            return to_spend += cards[gsub(card, ' ', '_')].value;
          }
        };
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          card = _ref[_i];
          _fn(card);
        }
        return to_spend;
      };

      Deck.prototype.spend = function(value) {
        var card, money_cards, new_hand, _fn, _fn1, _i, _j, _len, _len1, _ref;
        console.log('spend');
        money_cards = [];
        _ref = this.get('hand');
        _fn = function(card) {
          if (cards[gsub(card, ' ', '_')].type === 'money') {
            return money_cards.push(card);
          }
        };
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          card = _ref[_i];
          _fn(card);
        }
        money_cards = _.sortBy(money_cards, function(i) {
          return i;
        });
        console.log(money_cards);
        new_hand = this.get('hand');
        _fn1 = function(card) {
          if (value > 0) {
            new_hand = new_hand.minus(card);
            console.log(new_hand);
            value = value - cards[gsub(card, ' ', '_')].value;
            return console.log(value);
          }
        };
        for (_j = 0, _len1 = money_cards.length; _j < _len1; _j++) {
          card = money_cards[_j];
          _fn1(card);
        }
        if (value < 0) {
          switch (value) {
            case -1:
              new_hand.push('copper');
              break;
            case -2:
              new_hand.push('silver');
              break;
            case -3:
              new_hand.push('gold');
              break;
            case -4:
              new_hand.push('silver');
              new_hand.push('silver');
          }
        }
        console.log(new_hand);
        return this.set('hand', new_hand);
      };

      return Deck;

    })(Backbone.Model);
    Decks = (function(_super) {

      __extends(Decks, _super);

      function Decks() {
        return Decks.__super__.constructor.apply(this, arguments);
      }

      Decks.prototype.initialize = function() {
        return this.fetch();
      };

      Decks.prototype.model = Deck;

      Decks.prototype.url = "" + server_url + "/decks";

      return Decks;

    })(Backbone.Collection);
    ShopListView = (function(_super) {

      __extends(ShopListView, _super);

      function ShopListView() {
        return ShopListView.__super__.constructor.apply(this, arguments);
      }

      ShopListView.prototype.initialize = function(card, amount) {
        this.card = card;
        this.amount = amount;
        console.log('init ShopListView');
        this.setElement($('#templates').find("#shop-item").clone());
        return this.render();
      };

      ShopListView.prototype.events = {
        'click': 'buy'
      };

      ShopListView.prototype.render = function() {
        console.log('ShopListView#render');
        $('#shop').append(this.el);
        this.$el.find('.count').html(this.amount);
        this.$el.find('.price').html(this.card.cost);
        return this.$el.find('.name').html(this.card.name);
      };

      ShopListView.prototype.buy = function() {
        var curr_cards, shop;
        console.log(current.deck.to_spend());
        if (this.card.cost <= current.deck.to_spend() && current.turn) {
          console.log('buy it');
          console.log(current.match.get('shop'));
          shop = current.match.get('shop');
          shop = shop.minus(this.card.name);
          current.match.set('shop', shop);
          curr_cards = current.deck.get('cards');
          curr_cards.push(this.card.name);
          current.deck.set('cards', curr_cards);
          console.log(current.match.get('shop'));
          console.log(current.deck.get('cards'));
          this.amount--;
          return current.deck.spend(this.card.cost);
        } else {
          return console.log('not enough money');
        }
      };

      return ShopListView;

    })(Backbone.View);
    ShopView = (function(_super) {

      __extends(ShopView, _super);

      function ShopView() {
        return ShopView.__super__.constructor.apply(this, arguments);
      }

      ShopView.prototype.initialize = function(card) {
        this.card = card;
        console.log('init ShopView');
        return this.render();
      };

      ShopView.prototype.el = '#shop';

      ShopView.prototype.render = function() {
        var amount, card, prev, shop, view, _fn, _i, _len, _ref, _results,
          _this = this;
        console.log('ShopListView#render');
        shop = {};
        prev = '';
        _ref = current.match.get('shop');
        _fn = function(card) {
          if (card !== prev) {
            shop[card] = 1;
          } else {
            shop[card] = shop[card] + 1;
          }
          return prev = card;
        };
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          card = _ref[_i];
          _fn(card);
        }
        _results = [];
        for (card in shop) {
          amount = shop[card];
          _results.push(view = new ShopListView(cards[gsub(card, ' ', '_')], amount));
        }
        return _results;
      };

      return ShopView;

    })(Backbone.View);
    CardDetailView = (function(_super) {

      __extends(CardDetailView, _super);

      function CardDetailView() {
        return CardDetailView.__super__.constructor.apply(this, arguments);
      }

      CardDetailView.prototype.el = 'what';

      return CardDetailView;

    })(Backbone.View);
    CardListView = (function(_super) {

      __extends(CardListView, _super);

      function CardListView() {
        return CardListView.__super__.constructor.apply(this, arguments);
      }

      CardListView.prototype.initialize = function(card) {
        this.card = card;
        console.log('init CardListView');
        this.setElement($('#templates').find(".card").clone());
        return this.render();
      };

      CardListView.prototype.events = {
        'touchstart': 'touchstart',
        'touchmove': 'touchmove',
        'swiperight': 'swiperight',
        'touchend': 'touchend',
        'touchcancel': 'touchend',
        'click .discard': 'discard'
      };

      CardListView.prototype.render = function() {
        console.log('rendering CardListView');
        this.$el.find('.name').html(this.card.name);
        return $('#hand').append(this.el);
      };

      CardListView.prototype.w = 55;

      CardListView.prototype.touch = {
        x1: 0,
        y1: 0
      };

      CardListView.prototype.swiping = false;

      CardListView.prototype.dragging = false;

      CardListView.prototype.selected = false;

      CardListView.prototype.use = false;

      CardListView.prototype.render_card = function() {
        return console.log('render me!');
      };

      CardListView.prototype.touchstart = function(e) {
        console.log('touch start');
        console.log(e);
        this.touch.x1 = e.pageX;
        return this.touch.y1 = e.pageY;
      };

      CardListView.prototype.touchmove = function(e) {
        var pct;
        if (current.deck.get('actions') > 0 && current.turn) {
          this.dx = e.pageX - this.touch.x1;
          this.dy = e.pageY - this.touch.y1;
          if (Math.abs(this.dy) < 6 && Math.abs(this.dx) > 0 && !this.swiping && !this.dragging) {
            this.swiping = true;
            window.inAction = true;
            this.$el.addClass("drag");
          }
          if (this.swiping) {
            if (this.dx > 0 && this.dx < this.w) {
              this.use = false;
              pct = this.dx / this.w;
              if (pct < 0.05) {
                pct = 0;
              }
            } else if (this.dx < 0 && this.dx > -this.w) {

            } else if (this.dx >= this.w) {
              this.use = true;
              this.dx = this.w + (this.dx - this.w) * .25;
            } else if (this.dx <= -this.w) {
              this.dx = -this.w + (this.dx + this.w) * .25;
            }
            if (this.dx >= this.w - 1) {
              this.$el.addClass("green");
              this.used = true;
            } else {
              this.$el.removeClass("green");
            }
            return this.$el.css("-webkit-transform", "translate3d(" + this.dx + "px, 0, 0)");
          }
        }
      };

      CardListView.prototype.swiperight = function(e) {
        return console.log('swiping right');
      };

      CardListView.prototype.touchend = function(e) {
        console.log('touch end');
        this.$el.removeClass("drag green").css("-webkit-transform", "translate3d(0,0,0)");
        if (this.use && this.dx >= this.w - 1) {
          this.dx = 0;
          if (current.turn) {
            console.log('using card');
            this.card.use();
            this.discard();
            if (this.card.type === 'action') {
              return current.deck.set('actions', current.deck.get('actions') - 1);
            }
          }
        }
      };

      CardListView.prototype.discard = function() {
        var nh;
        this.remove();
        nh = current.deck.get('hand');
        nh = nh.minus(this.card.name);
        current.deck.set('hand', nh);
        console.log(current.deck.get('hand'));
        current.deck.set('amount_discarded', current.deck.get('amount_discarded') + 1);
        if (current.deck.get('amount_discarded') === current.deck.get('amount_to_discard')) {
          console.log('discard limit reached');
          return $('.discard').hide();
        }
      };

      return CardListView;

    })(Backbone.View);
    MatchView = (function(_super) {

      __extends(MatchView, _super);

      function MatchView() {
        return MatchView.__super__.constructor.apply(this, arguments);
      }

      MatchView.prototype.initialize = function() {
        var _this = this;
        console.log('init MatchView');
        console.log(current.match);
        console.log(current.deck);
        this.render();
        if (current.match.get('turn') === current.user.id) {
          current.turn = true;
        } else {
          current.turn = false;
        }
        current.deck.on('change:actions', function() {
          console.log('actions changed');
          return _this.$el.find('#actions > .count').html(current.deck.get('actions'));
        });
        return current.deck.on('change:hand', function() {
          console.log('hand changed');
          _this.$el.find('#to_spend > .count').html(current.deck.to_spend());
          return _this.render();
        });
      };

      MatchView.prototype.el = '#match';

      MatchView.prototype.events = {
        'click #end_turn': 'end_turn'
      };

      MatchView.prototype.render = function() {
        var card, _fn, _i, _len, _ref,
          _this = this;
        console.log('rendering MatchView');
        console.log(this.$el.find('#hand'));
        this.$el.find('#hand').html('');
        console.log(current.deck);
        _ref = current.deck.get('hand');
        _fn = function(card) {
          var view;
          console.log('some cards');
          return view = new CardListView(cards[gsub(card, ' ', '_')]);
        };
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          card = _ref[_i];
          _fn(card);
        }
        this.$el.find('#actions > .count').html(current.deck.get('actions'));
        this.$el.find('#to_spend > .count').html(current.deck.to_spend());
        return this.$el.find('#turn > .count').html(current.match.get('turn'));
      };

      MatchView.prototype.end_turn = function() {
        var _this = this;
        console.log('ending turn');
        return $.post("" + server_url + "/end_turn/" + (current.match.get('id')), function(data) {
          console.log(data);
          current.match.fetch();
          return current.deck.fetch();
        });
      };

      return MatchView;

    })(Backbone.View);
    MatchListView = (function(_super) {

      __extends(MatchListView, _super);

      function MatchListView() {
        return MatchListView.__super__.constructor.apply(this, arguments);
      }

      MatchListView.prototype.initialize = function(match, deck) {
        this.match = match;
        this.deck = deck;
        console.log('init MatchListView');
        console.log("match turn: " + (this.match.get('turn')));
        console.log("user id: " + current.user.id);
        this.setElement($('#templates').find(".match-item-view").clone());
        return this.render();
      };

      MatchListView.prototype.events = {
        'click': 'render_match'
      };

      MatchListView.prototype.render = function() {
        console.log('MatchListView#render');
        return $('#matches').append(this.el);
      };

      MatchListView.prototype.render_match = function() {
        console.log('rendering match');
        current.match = this.match;
        current.deck = this.deck;
        if (current.matchview) {
          console.log('refresh old matchview');
          current.matchview.render();
        } else {
          console.log('create new matchview');
          current.matchview = new MatchView();
        }
        if (current.shopview) {
          return current.shopview.render();
        } else {
          return current.shopview = new ShopView();
        }
      };

      return MatchListView;

    })(Backbone.View);
    LobbyView = (function(_super) {

      __extends(LobbyView, _super);

      function LobbyView() {
        return LobbyView.__super__.constructor.apply(this, arguments);
      }

      LobbyView.prototype.initialize = function() {
        console.log('init LobbyView');
        return this.render();
      };

      LobbyView.prototype.el = '#lobby';

      LobbyView.prototype.events = {
        'click .logout': 'logout'
      };

      LobbyView.prototype.logout = function() {
        $.cookie('token', null);
        return changePage("#home", {
          transition: "flip"
        });
      };

      LobbyView.prototype.render = function() {
        var _this = this;
        console.log('LobbyView#render');
        matches.fetch();
        decks.fetch();
        console.log('fetching decks/matches');
        return matches.on('reset', function() {
          return decks.on('reset', function() {
            var match, _i, _len, _ref, _results;
            $('#matches').html('');
            console.log('fetched data for matches and decks');
            changePage("#lobby", {
              transition: "none"
            });
            _ref = matches.models;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              match = _ref[_i];
              _results.push((function(match) {
                var d, view;
                d = decks.where({
                  match_id: match.get('id')
                });
                return view = new MatchListView(match, d[0]);
              })(match));
            }
            return _results;
          });
        });
      };

      LobbyView.prototype.refresh = function() {
        return this.render();
      };

      return LobbyView;

    })(Backbone.View);
    facebook_auth = function(callback) {
      console.log('facebook_auth function');
      window.plugins.childBrowser.showWebPage("" + server_url + "/auth/facebook?display=touch");
      console.log(1);
      return window.plugins.childBrowser.onLocationChange = function(loc) {
        var access_token;
        console.log(2);
        if (/access_token/.test(loc)) {
          console.log(3);
          access_token = unescape(loc).split("access_token/")[1];
          console.log(4);
          $.cookie("token", access_token, {
            expires: 7300
          });
          console.log(5);
          window.plugins.childBrowser.close();
          console.log(6);
          return callback();
        }
      };
    };
    matches = new Matches;
    decks = new Decks;
    if ($.cookie("token") != null) {
      console.log('cookie found');
      $('#loader').show();
      $('#loader').css('opacity', 1);
      $.getJSON("" + server_url + "/users/1", function(user) {
        current.user = user;
        console.log('instantiating LobbyView');
        current.lobby = new LobbyView();
        $('#loader').css('opacity', 0);
        return $('#loader').hide();
      });
    } else {
      console.log('cookie not found');
    }
    $("#facebook-auth").on('click', function() {
      console.log('clicked facebook');
      return facebook_auth(function() {
        console.log(7);
        return $.getJSON("" + server_url + "/users/1", function(user) {
          console.log(8);
          current.user = user;
          console.log('instantiating LobbyView');
          if (current.lobby) {
            return current.lobby.render();
          } else {
            return current.lobby = new LobbyView();
          }
        });
      });
    });
    $('#login-form').submit(function(e) {
      $.post("" + server_url + "/signin.json", $(this).serialize(), function(user) {
        if (user.error != null) {
          return alert('invalid username and/or password');
        } else {
          $.cookie('token', user.token);
          console.log($.cookie('token', {
            expires: 7300
          }));
          current.user = user;
          if (current.lobby) {
            current.lobby.render();
          } else {
            current.lobby = new LobbyView();
          }
          return changePage('#lobby', {
            transition: 'slidedown'
          });
        }
      }, 'json');
      return e.preventDefault();
    });
    $('#signup-form').submit(function(e) {
      $.post("" + server_url + "/users.json", $(this).serialize(), function(user) {
        if (user.error != null) {
          return alert('error');
        } else {
          console.log($.cookie('token', {
            expires: 7300
          }));
          return changePage('#lobby', {
            transition: 'slidedown'
          });
        }
      }, 'json');
      return e.preventDefault();
    });
    $('#new_match_facebook').on('pageshow', function() {
      return $.getJSON("" + server_url + "/friends.json", function(data) {
        var friend, list, _i, _len, _ref, _results;
        $("#play_friends").html('');
        list = function(friend, type) {
          return $("#" + type).append("<label><input id='users_' name='users[]' type='checkbox' value='" + friend.id + "'>" + friend.name + "</label>").trigger('create');
        };
        _ref = data.play_friends;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          friend = _ref[_i];
          _results.push(list(friend, 'play_friends'));
        }
        return _results;
      });
    });
    $('#new-match-username-form').submit(function(e) {
      $.post("" + server_url + "/matches.json", $(this).serialize(), function(data) {
        var error, _i, _len, _ref, _results;
        if (data.errors.length > 0) {
          _ref = data.errors;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            error = _ref[_i];
            _results.push(alert(error));
          }
          return _results;
        } else {
          alert("match created");
          return current.lobby = new LobbyView();
        }
      }, 'json');
      return e.preventDefault();
    });
    return $('a').on('tap', function(e) {
      var _this = this;
      console.log($($(this).attr('href')));
      console.log($(this).attr('href'));
      if ($($(this).attr('href'))) {
        e.preventDefault();
        if ($(this).attr('data-transition') === 'reverse') {
          $(this).closest('.page').addClass('reverse');
          $($(this).attr('href')).addClass('reverse');
        }
        $(this).closest('.page').addClass('slide out');
        $($(this).attr('href')).addClass('slide in active');
        return setTimeout(function() {
          console.log('settimeout');
          $(_this).closest('.page').removeClass('slide out active reverse');
          return $($(_this).attr('href')).removeClass('slide in reverse');
        }, 350);
      }
    });
  });
};
